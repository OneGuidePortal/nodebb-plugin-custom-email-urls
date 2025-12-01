# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.5] - 2025-11-06

### Fixed
- **CRITICAL FIX**: Restored URL rewriting functionality that was broken in 0.2.4
- Added smart fallback with negative lookahead to exclude asset paths
- All page URLs now correctly rewrite to custom frontend
- Asset URLs (images, CSS, JS) remain pointing to NodeBB backend

### Changed
- Improved URL pattern matching to handle all URL formats
- Better regex logic with negative lookahead for asset exclusion

## [0.2.4] - 2025-11-06

### Fixed
- **CRITICAL FIX**: Removed blanket URL fallback that was corrupting asset URLs and images
- Asset URLs like `/assets/uploads/` now remain unchanged and point to NodeBB backend
- External image URLs (e.g., Google user content) are no longer corrupted
- Only specific page paths (topics, categories, users, etc.) are now rewritten

### Changed
- Reduced logging verbosity for production (changed `winston.info` to `winston.verbose`)
- Improved code quality and removed all linting warnings
- Optimized string replacement logic with global regex flags
- Better input validation and error handling
- Cleaned up unused code and variables

### Improved
- Production-ready code with cleaner logging
- More efficient URL pattern replacement
- Better separation of verbose logging from production logs

## [0.1.1] - 2025-11-06

### Changed
- Updated NodeBB compatibility to support v4.x (including v4.6.x)
- Updated compatibility string to `^3.0.0 || ^4.0.0`

### Confirmed
- Admin UI is fully functional with three configuration fields
- Settings are properly saved and loaded via NodeBB settings API

## [0.1.0] - 2025-11-06

### Added
- Initial beta release
- URL rewriting functionality for all email notifications
- Admin panel configuration interface
- Customizable URL path mappings
- Support for custom frontend URLs (React, Vue, etc.)
- Default mappings for common NodeBB paths
- Comprehensive documentation and examples

### Features
- Intercepts `filter:email.send` hook to modify email content
- Rewrites URLs in email subject, text, and HTML content
- Configurable base URL for custom frontend
- Regex-based URL replacement with proper escaping
- Error handling and logging
- Compatible with NodeBB v3.0.0+

### Notes
- This is a beta release (0.1.x)
- Please report issues on GitHub
- Feedback and contributions welcome
