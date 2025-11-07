'use strict';

const meta = require.main.require('./src/meta');
const winston = require.main.require('winston');

const plugin = {};

/**
 * Rewrite URLs in email content from NodeBB URLs to custom frontend URLs
 */
plugin.rewriteEmailUrls = async function (data) {
	try {
		const settings = await meta.settings.get('custom-email-urls');

		// Get the custom frontend URL from settings
		const customFrontendUrl = settings.customFrontendUrl;
		const nodebbUrl = settings.nodebbUrl || meta.config.url;

		// If no custom URL is configured, return the original data
		if (!customFrontendUrl) {
			winston.warn('[plugin/custom-email-urls] No custom frontend URL configured. Skipping URL rewrite.');
			return data;
		}

		// Ensure URLs don't have trailing slashes
		const fromUrl = nodebbUrl.replace(/\/$/, '');
		const toUrl = customFrontendUrl.replace(/\/$/, '');

		winston.verbose(`[plugin/custom-email-urls] Rewriting URLs from ${fromUrl} to ${toUrl}`);

		// Rewrite URLs in subject
		if (data.subject) {
			data.subject = replaceUrls(data.subject, fromUrl, toUrl, settings);
		}

		// Rewrite URLs in text content
		if (data.text) {
			data.text = replaceUrls(data.text, fromUrl, toUrl, settings);
		}

		// Rewrite URLs in HTML content
		if (data.html) {
			data.html = replaceUrls(data.html, fromUrl, toUrl, settings);
		}

		return data;
	} catch (err) {
		winston.error('[plugin/custom-email-urls] Error rewriting email URLs:', err);
		return data;
	}
};

/**
 * Replace NodeBB URLs with custom frontend URLs
 */
function replaceUrls(content, fromUrl, toUrl, settings) {
	if (!content || typeof content !== 'string') {
		return content;
	}

	// Define URL mappings for different NodeBB paths
	const urlMappings = settings.urlMappings ? parseUrlMappings(settings.urlMappings) : getDefaultUrlMappings();

	// Apply custom mappings
	let result = content;
	for (const [nodebbPath, customPath] of Object.entries(urlMappings)) {
		// Match both plain URLs and URLs in href attributes
		const patterns = [
			// Plain URLs (with word boundaries)
			new RegExp(`${escapeRegex(fromUrl)}${escapeRegex(nodebbPath)}([?&#]|$)`, 'g'),
			// URLs in href attributes
			new RegExp(`(href=["'])${escapeRegex(fromUrl)}${escapeRegex(nodebbPath)}([?&#"'])`, 'g'),
		];

		patterns.forEach((pattern, index) => {
			if (index === 0) {
				// Plain URL replacement
				result = result.replace(pattern, `${toUrl}${customPath}$1`);
			} else {
				// href attribute replacement
				result = result.replace(pattern, `$1${toUrl}${customPath}$2`);
			}
		});
	}

	// Fallback: replace any remaining instances of the base NodeBB URL
	result = result.replace(new RegExp(escapeRegex(fromUrl), 'g'), toUrl);

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
 * Parse custom URL mappings from settings
 * Format: nodebb_path=custom_path (one per line)
 */
function parseUrlMappings(mappingsString) {
	const mappings = getDefaultUrlMappings();

	if (!mappingsString || typeof mappingsString !== 'string') {
		return mappings;
	}

	const lines = mappingsString.split('\n').filter(line => line.trim());

	for (const line of lines) {
		const [nodebbPath, customPath] = line.split('=').map(s => s.trim());
		if (nodebbPath && customPath) {
			mappings[nodebbPath] = customPath;
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

module.exports = plugin;
