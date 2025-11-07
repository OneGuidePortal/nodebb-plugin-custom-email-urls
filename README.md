# NodeBB Plugin: Custom Email URLs

Override NodeBB email URLs to point to your custom React frontend instead of the default NodeBB interface.

## Use Case

This plugin is designed for setups where you have:
- A custom React (or any other) frontend application
- NodeBB running as the backend/API
- A need for email notifications to link to your custom frontend instead of NodeBB's built-in UI

## Features

- Automatically rewrites all URLs in email notifications (subject, text, and HTML content)
- Configurable base URL for your custom frontend
- Customizable URL path mappings (e.g., `/topic/` → `/discussion/`)
- Works with all NodeBB email types (notifications, password resets, registrations, etc.)
- Admin panel configuration interface
- Fallback to default behavior if not configured

## Installation

### Method 1: NPM (recommended for production)

```bash
npm install nodebb-plugin-custom-email-urls
```

### Method 2: Local Development

1. Clone this repository into your NodeBB's `node_modules` directory:
```bash
cd /path/to/nodebb/node_modules
git clone https://github.com/yourusername/nodebb-plugin-custom-email-urls.git
```

2. Navigate to your NodeBB root directory and activate the plugin:
```bash
cd /path/to/nodebb
./nodebb build
./nodebb restart
```

### Method 3: Admin Panel

1. Go to your NodeBB Admin Panel
2. Navigate to "Extend" → "Plugins"
3. Search for "Custom Email URLs"
4. Click "Install"
5. Activate the plugin and restart NodeBB

## Configuration

### Admin Panel Configuration

1. Go to your NodeBB Admin Panel
2. Navigate to "Plugins" → "Custom Email URLs"
3. Configure the following settings:

#### Custom Frontend URL (Required)
The base URL of your custom frontend application.

**Example:** `https://your-react-app.com`

**Important:** Do not include a trailing slash.

#### NodeBB URL (Optional)
Your NodeBB installation URL. Leave empty to use the default from `config.json`.

#### Custom URL Mappings (Optional)
Override default path mappings if your custom frontend uses different routes.

**Format:** One mapping per line as `nodebb_path=custom_path`

**Example:**
```
/topic/=/discussion/
/user/=/profile/
/category/=/forum/
/notifications=/alerts
```

### Default URL Mappings

If no custom mappings are specified, the plugin uses these defaults:

| NodeBB Path | Custom Frontend Path |
|------------|---------------------|
| `/topic/` | `/topic/` |
| `/post/` | `/post/` |
| `/user/` | `/user/` |
| `/category/` | `/category/` |
| `/notifications` | `/notifications` |
| `/unsubscribe/` | `/unsubscribe/` |
| `/reset/` | `/reset/` |
| `/register` | `/register` |
| `/login` | `/login` |
| `/tags/` | `/tags/` |
| `/groups/` | `/groups/` |

## How It Works

The plugin hooks into NodeBB's email sending process using the `filter:email.send` hook. Before each email is sent, it:

1. Retrieves the configured custom frontend URL
2. Scans the email subject, text, and HTML content for NodeBB URLs
3. Applies the configured URL mappings
4. Replaces all matching URLs with your custom frontend URLs
5. Returns the modified email data to NodeBB for sending

## Example

### Before (NodeBB URL):
```
New reply in: https://nodebb.example.com/topic/123/hello-world
View your notifications: https://nodebb.example.com/notifications
```

### After (Custom Frontend URL):
```
New reply in: https://your-react-app.com/topic/123/hello-world
View your notifications: https://your-react-app.com/notifications
```

### With Custom Mappings:
If you configure `/topic/=/discussion/`:
```
New reply in: https://your-react-app.com/discussion/123/hello-world
```

## Testing

After installation and configuration:

1. Trigger a test email from NodeBB (e.g., post a reply to generate a notification email)
2. Check the received email's links
3. Verify that all URLs point to your custom frontend
4. Check the NodeBB logs for any warnings or errors

## Troubleshooting

### URLs are not being rewritten

1. Verify the plugin is active in Admin → Extend → Plugins
2. Check that the "Custom Frontend URL" is configured in the plugin settings
3. Restart NodeBB after making configuration changes
4. Check NodeBB logs for errors: `./nodebb log`

### Some URLs are incorrect

1. Review your custom URL mappings
2. Ensure paths include leading slashes and trailing slashes where appropriate
3. Test with default mappings first, then add custom ones incrementally

### Plugin not appearing in Admin Panel

1. Ensure the plugin is properly installed in `node_modules`
2. Run `./nodebb build` to rebuild NodeBB
3. Restart NodeBB: `./nodebb restart`

## Logging

The plugin logs its activity to the NodeBB console:

- **Verbose logs:** Shows when URLs are being rewritten (requires verbose logging enabled)
- **Warning logs:** Shows when custom frontend URL is not configured
- **Error logs:** Shows any errors during URL rewriting

Enable verbose logging in your NodeBB `config.json`:
```json
{
  "logLevel": "verbose"
}
```

## Development

### Project Structure

```
nodebb-plugin-custom-email-urls/
├── library.js                               # Main plugin logic
├── plugin.json                              # Plugin metadata and hooks
├── package.json                             # NPM package configuration
├── README.md                                # Documentation
└── templates/
    └── admin/
        └── plugins/
            └── custom-email-urls.tpl        # Admin panel template
```

### Key Functions

- `rewriteEmailUrls(data)` - Main hook that processes email data
- `replaceUrls(content, fromUrl, toUrl, settings)` - URL replacement logic
- `getDefaultUrlMappings()` - Returns default path mappings
- `parseUrlMappings(mappingsString)` - Parses custom mappings from settings

## Compatibility

- NodeBB v3.0.0 or higher
- Works with all NodeBB email templates
- Compatible with other email-related plugins

## License

MIT

## Support

For issues, questions, or contributions, please visit:
- GitHub Issues: [Create an issue]
- NodeBB Community: [https://community.nodebb.org]

## Changelog

### Version 0.1.0
- Initial release
- Basic URL rewriting functionality
- Admin panel configuration
- Custom URL mappings support
