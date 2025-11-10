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
				<label>Custom URL Mappings</label>
				<p class="help-block">
					Map NodeBB paths to your custom frontend paths. Leave empty to use the same path.
				</p>

				<div class="url-mappings-container">
					<div class="row mapping-header" style="font-weight: bold; margin-bottom: 10px;">
						<div class="col-sm-5">NodeBB Path</div>
						<div class="col-sm-5">Custom Frontend Path</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/topic/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_topic" class="form-control" placeholder="/topic/" value="{mapping_topic}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Topic pages</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/post/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_post" class="form-control" placeholder="/post/" value="{mapping_post}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Post links</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/user/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_user" class="form-control" placeholder="/user/" value="{mapping_user}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">User profiles</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/category/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_category" class="form-control" placeholder="/category/" value="{mapping_category}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Categories</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/notifications" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_notifications" class="form-control" placeholder="/notifications" value="{mapping_notifications}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Notifications</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/unsubscribe/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_unsubscribe" class="form-control" placeholder="/unsubscribe/" value="{mapping_unsubscribe}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Unsubscribe</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/reset/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_reset" class="form-control" placeholder="/reset/" value="{mapping_reset}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Password reset</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/register" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_register" class="form-control" placeholder="/register" value="{mapping_register}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Registration</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/login" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_login" class="form-control" placeholder="/login" value="{mapping_login}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Login page</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/tags/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_tags" class="form-control" placeholder="/tags/" value="{mapping_tags}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Tag pages</span>
						</div>
					</div>

					<div class="mapping-row row" style="margin-bottom: 10px;">
						<div class="col-sm-5">
							<input type="text" class="form-control" value="/groups/" readonly style="background-color: #f5f5f5;">
						</div>
						<div class="col-sm-5">
							<input type="text" name="mapping_groups" class="form-control" placeholder="/groups/" value="{mapping_groups}">
						</div>
						<div class="col-sm-2">
							<span class="help-block" style="margin: 0; line-height: 34px;">Group pages</span>
						</div>
					</div>
				</div>
			</div>

			<button type="button" class="btn btn-primary" id="save">Save Settings</button>
		</form>
	</div>
</div>
