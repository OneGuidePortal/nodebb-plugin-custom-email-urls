'use strict';

const meta = require.main.require('./src/meta');
const winston = require.main.require('winston');
const topics = require.main.require('./src/topics');

const plugin = {};

/**
 * Rewrite URLs in email content from NodeBB URLs to custom frontend URLs
 */
plugin.rewriteEmailUrls = async function (data) {
	try {
		const settings = await meta.settings.get('custom-email-urls');

		// Get the custom frontend URL from settings
		const customFrontendUrl = settings.customFrontendUrl;
		// Use nodebbUrl from settings if provided and not empty, otherwise use meta.config.url
		const nodebbUrl = (settings.nodebbUrl && settings.nodebbUrl.trim()) ? settings.nodebbUrl.trim() : meta.config.url;

		// If no custom URL is configured, pass through without rewriting
		if (!customFrontendUrl || !customFrontendUrl.trim() || !nodebbUrl || typeof nodebbUrl !== 'string') {
			winston.verbose('[plugin/custom-email-urls] Skipping URL rewrite - configuration missing or invalid');
			return data;
		}

		// Ensure URLs don't have trailing slashes
		const fromUrl = nodebbUrl.replace(/\/$/, '');
		const toUrl = customFrontendUrl.trim().replace(/\/$/, '');

		winston.verbose(`[plugin/custom-email-urls] Rewriting URLs from ${fromUrl} to ${toUrl}`);

		// Rewrite URLs in subject
		if (data.subject) {
			data.subject = await replaceUrls(data.subject, fromUrl, toUrl, settings);
		}

		// Rewrite URLs in plaintext content
		if (data.plaintext) {
			data.plaintext = await replaceUrls(data.plaintext, fromUrl, toUrl, settings);
		}

		// Rewrite URLs in HTML content
		if (data.html) {
			data.html = await replaceUrls(data.html, fromUrl, toUrl, settings);
		}

		return data;
	} catch (err) {
		winston.error('[plugin/custom-email-urls] Error rewriting email URLs:', err);
		return data;
	}
};

/**
 * Replace NodeBB URLs with custom frontend URLs using pattern-based transformations
 */
async function replaceUrls(content, fromUrl, toUrl, settings) {
	if (!content || typeof content !== 'string') {
		return content;
	}

	let result = content;

	// Handle topic URLs with pattern transformation
	if (settings.mapping_topic && settings.mapping_topic.includes('{')) {
		result = await transformUrlPattern(result, fromUrl, toUrl, settings.mapping_topic, 'topic');
	}

	// Handle category URLs with pattern transformation
	if (settings.mapping_category && settings.mapping_category.includes('{')) {
		result = await transformUrlPattern(result, fromUrl, toUrl, settings.mapping_category, 'category');
	}

	// Handle user URLs with pattern transformation
	if (settings.mapping_user && settings.mapping_user.includes('{')) {
		result = await transformUrlPattern(result, fromUrl, toUrl, settings.mapping_user, 'user');
	}

	// Apply simple path replacements for URLs without patterns
	const urlMappings = buildUrlMappings(settings);
	for (const [nodebbPath, customPath] of Object.entries(urlMappings)) {
		// Skip if this path uses pattern transformation (has placeholders)
		if (customPath && customPath.includes('{')) {
			continue;
		}

		// Replace NodeBB path with custom path, preserving everything after the path
		// Match: fromUrl + nodebbPath + (rest of URL)
		const urlPattern = new RegExp(
			`${escapeRegex(fromUrl)}${escapeRegex(nodebbPath)}`,
			'g'
		);
		result = result.replace(urlPattern, `${toUrl}${customPath}`);
	}

	// Smart fallback: Replace remaining NodeBB URLs that aren't assets
	// This catches any URLs not handled by specific path mappings above
	// But excludes asset paths to prevent image/file corruption
	const assetPaths = ['/assets/', '/plugins/', '/uploads/', '/sounds/', '/language/', '/css/', '/javascript/'];

	// Build a regex that matches fromUrl but NOT when followed by asset paths
	// Negative lookahead to exclude asset URLs
	const assetPathsPattern = assetPaths.map(escapeRegex).join('|');
	const smartFallbackPattern = new RegExp(
		`${escapeRegex(fromUrl)}(?!(?:${assetPathsPattern}))`,
		'g'
	);

	result = result.replace(smartFallbackPattern, toUrl);

	return result;
}

/**
 * Transform URLs using custom patterns with placeholders like {tid}, {cid}, {slug}
 */
async function transformUrlPattern(content, fromUrl, toUrl, customPattern, entityType) {
	winston.verbose(`[plugin/custom-email-urls] Transforming ${entityType} URLs with pattern: ${customPattern}`);

	// Build regex to match NodeBB URLs and extract IDs/slugs
	let nodebbPattern;
	let extractIds;

	if (entityType === 'topic') {
		// Match /topic/123/slug-text or /topic/123
		nodebbPattern = new RegExp(
			`${escapeRegex(fromUrl)}/topic/(\\d+)(?:/([^\\s"'<>/?#]+))?`,
			'g'
		);
		extractIds = (matches) => [...new Set(matches.map(m => m[1]))]; // Extract unique tids
	} else if (entityType === 'category') {
		// Match /category/123/slug-text or /category/123
		nodebbPattern = new RegExp(
			`${escapeRegex(fromUrl)}/category/(\\d+)(?:/([^\\s"'<>/?#]+))?`,
			'g'
		);
		extractIds = (matches) => [...new Set(matches.map(m => m[1]))]; // Extract unique cids
	} else if (entityType === 'user') {
		// Match /user/username
		nodebbPattern = new RegExp(
			`${escapeRegex(fromUrl)}/user/([^\\s"'<>/?#]+)`,
			'g'
		);
		extractIds = (matches) => [...new Set(matches.map(m => m[1]))]; // Extract unique userslug
	} else {
		return content;
	}

	const matches = [...content.matchAll(nodebbPattern)];
	if (matches.length === 0) {
		return content;
	}

	const ids = extractIds(matches);
	winston.verbose(`[plugin/custom-email-urls] Found ${ids.length} unique ${entityType} URLs`);

	// Fetch additional data if pattern requires it (e.g., {cid} for topics)
	let dataMap = {};
	try {
		if (entityType === 'topic' && customPattern.includes('{cid}')) {
			// Fetch category IDs for topics
			const topicData = await topics.getTopicsFields(ids, ['tid', 'cid', 'slug']);
			topicData.forEach((topic) => {
				if (topic && topic.tid) {
					dataMap[topic.tid] = topic;
				}
			});
		} else if (entityType === 'topic') {
			// Just get slug if needed
			const topicData = await topics.getTopicsFields(ids, ['tid', 'slug']);
			topicData.forEach((topic) => {
				if (topic && topic.tid) {
					dataMap[topic.tid] = topic;
				}
			});
		}
	} catch (err) {
		winston.error(`[plugin/custom-email-urls] Error fetching ${entityType} data:`, err);
		return content; // Return original content if database lookup fails
	}

	// Replace URLs with custom pattern
	const result = content.replace(nodebbPattern, (_match, id, slug) => {
		const data = dataMap[id] || {};

		// Build replacement URL by substituting placeholders
		let newPath = customPattern;

		if (entityType === 'topic') {
			newPath = newPath.replace(/{tid}/g, id);
			newPath = newPath.replace(/{cid}/g, data.cid || '');
			newPath = newPath.replace(/{slug}/g, slug || data.slug || '');
		} else if (entityType === 'category') {
			newPath = newPath.replace(/{cid}/g, id);
			newPath = newPath.replace(/{slug}/g, slug || '');
		} else if (entityType === 'user') {
			newPath = newPath.replace(/{userslug}/g, id);
			newPath = newPath.replace(/{uid}/g, data.uid || '');
		}

		return `${toUrl}${newPath}`;
	});

	return result;
}

/**
 * Get default URL mappings for common NodeBB paths
 */
function getDefaultUrlMappings() {
	return {
		'/topic/': '/topic/',
		'/post/': '/post/',
		'/user/': '/user/',
		'/category/': '/category/',
		'/notifications': '/notifications',
		'/unsubscribe/': '/unsubscribe/',
		'/reset/': '/reset/',
		'/register': '/register',
		'/login': '/login',
		'/tags/': '/tags/',
		'/groups/': '/groups/',
	};
}

/**
 * Build URL mappings from individual settings fields
 */
function buildUrlMappings(settings) {
	const mappings = {};

	// Map individual fields to their NodeBB paths
	const fieldMap = {
		mapping_topic: '/topic/',
		mapping_post: '/post/',
		mapping_user: '/user/',
		mapping_category: '/category/',
		mapping_notifications: '/notifications',
		mapping_unsubscribe: '/unsubscribe/',
		mapping_reset: '/reset/',
		mapping_register: '/register',
		mapping_login: '/login',
		mapping_tags: '/tags/',
		mapping_groups: '/groups/',
	};

	// Build mappings from settings, using defaults if not set
	const defaults = getDefaultUrlMappings();
	for (const [fieldName, nodebbPath] of Object.entries(fieldMap)) {
		if (settings[fieldName] && settings[fieldName].trim()) {
			mappings[nodebbPath] = settings[fieldName].trim();
		} else {
			mappings[nodebbPath] = defaults[nodebbPath];
		}
	}

	return mappings;
}

/**
 * Escape special regex characters
 */
function escapeRegex(string) {
	return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/**
 * Add navigation item to admin panel
 */
plugin.addAdminNavigation = async function (header) {
	header.plugins.push({
		route: '/plugins/custom-email-urls',
		icon: 'fa-envelope',
		name: 'Custom Email URLs',
	});

	return header;
};

/**
 * Initialize plugin and register admin routes
 */
plugin.init = function (params, callback) {
	const { router, middleware } = params;

	const renderAdmin = function (_req, res) {
		res.render('admin/plugins/custom-email-urls', {
			title: 'Custom Email URLs',
		});
	};

	router.get('/admin/plugins/custom-email-urls', middleware.admin.buildHeader, renderAdmin);
	router.get('/api/admin/plugins/custom-email-urls', renderAdmin);

	callback();
};

module.exports = plugin;
