# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
