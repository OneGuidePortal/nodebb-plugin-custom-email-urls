<div class="row">
	<div class="col-sm-2 col-xs-12 settings-header">Custom Email URLs</div>
	<div class="col-sm-10 col-xs-12">
		<form role="form" class="custom-email-urls-settings">
			<div class="form-group">
				<label for="customFrontendUrl">Custom Frontend URL</label>
				<input type="text" id="customFrontendUrl" name="customFrontendUrl" title="Custom Frontend URL" class="form-control" placeholder="https://your-react-app.com" value="{customFrontendUrl}">
				<p class="help-block">
					The base URL of your custom React frontend. All NodeBB URLs in emails will be rewritten to point to this domain.
					<br><strong>Example:</strong> https://your-react-app.com (without trailing slash)
				</p>
			</div>

			<div class="form-group">
				<label for="nodebbUrl">NodeBB URL (optional)</label>
				<input type="text" id="nodebbUrl" name="nodebbUrl" title="NodeBB URL" class="form-control" placeholder="{config.url}" value="{nodebbUrl}">
				<p class="help-block">
					Your NodeBB installation URL. Leave empty to use the default from config.json.
					<br><strong>Current default:</strong> {config.url}
				</p>
			</div>

			<div class="form-group">
				<label for="urlMappings">Custom URL Mappings (optional)</label>
				<textarea id="urlMappings" name="urlMappings" title="URL Mappings" class="form-control" rows="10" placeholder="/topic/=/discussion/&#10;/user/=/profile/">{urlMappings}</textarea>
				<p class="help-block">
					Override default path mappings. One mapping per line in format: <code>nodebb_path=custom_path</code>
					<br><strong>Example:</strong>
					<br><code>/topic/=/discussion/</code>
					<br><code>/user/=/profile/</code>
					<br><code>/category/=/forum/</code>
					<br><br><strong>Default mappings:</strong>
					<br>/topic/ → /topic/
					<br>/post/ → /post/
					<br>/user/ → /user/
					<br>/category/ → /category/
					<br>/notifications → /notifications
					<br>/unsubscribe/ → /unsubscribe/
					<br>/reset/ → /reset/
					<br>/register → /register
					<br>/login → /login
					<br>/tags/ → /tags/
					<br>/groups/ → /groups/
				</p>
			</div>

			<button type="button" class="btn btn-primary" id="save">Save Settings</button>
		</form>
	</div>
</div>

<script>
	require(['settings'], function (Settings) {
		Settings.load('custom-email-urls', $('.custom-email-urls-settings'));

		$('#save').on('click', function () {
			Settings.save('custom-email-urls', $('.custom-email-urls-settings'), function () {
				app.alert({
					type: 'success',
					alert_id: 'custom-email-urls-saved',
					title: 'Settings Saved',
					message: 'Custom Email URLs settings have been saved successfully.',
					timeout: 3000
				});
			});
		});
	});
</script>
