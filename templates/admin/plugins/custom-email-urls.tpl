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
				<label>URL Transformation Patterns</label>
				<p class="help-block">
					Configure how NodeBB URLs are transformed to your custom frontend URLs. Use the available variables shown below.
					<br><strong>Leave empty to use simple path replacement (domain swap only).</strong>
				</p>

				<div class="url-mappings-container">
					<!-- Topics Section -->
					<div style="border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px;">
						<div style="margin-bottom: 10px;">
							<strong style="font-size: 14px;">Topics</strong>
							<span style="margin-left: 15px; color: #666;">NodeBB Format: <code>/topic/{topic_id}/{topic_slug}</code></span>
						</div>
						<div style="margin-bottom: 8px;">
							<label style="font-weight: normal; margin-bottom: 3px;">Custom URL Pattern:</label>
							<input type="text" name="mapping_topic" class="form-control" placeholder="/topic/{topic_id}/{topic_slug}" value="{mapping_topic}">
						</div>
						<div style="background-color: #f5f5f5; padding: 8px; border-radius: 3px;">
							<small><strong>Available variables:</strong> <code>{tid}</code> = topic_id, <code>{cid}</code> = category_id, <code>{slug}</code> = topic_slug</small>
							<br><small style="color: #666;"><strong>Example:</strong> <code>/topic/{cid}/{tid}</code> to get /topic/1/24 format</small>
						</div>
					</div>

					<!-- Categories Section -->
					<div style="border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px;">
						<div style="margin-bottom: 10px;">
							<strong style="font-size: 14px;">Categories</strong>
							<span style="margin-left: 15px; color: #666;">NodeBB Format: <code>/category/{category_id}/{category_slug}</code></span>
						</div>
						<div style="margin-bottom: 8px;">
							<label style="font-weight: normal; margin-bottom: 3px;">Custom URL Pattern:</label>
							<input type="text" name="mapping_category" class="form-control" placeholder="/category/{category_id}/{category_slug}" value="{mapping_category}">
						</div>
						<div style="background-color: #f5f5f5; padding: 8px; border-radius: 3px;">
							<small><strong>Available variables:</strong> <code>{cid}</code> = category_id, <code>{slug}</code> = category_slug</small>
							<br><small style="color: #666;"><strong>Example:</strong> <code>/category/{cid}</code> to remove the slug</small>
						</div>
					</div>

					<!-- Users Section -->
					<div style="border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px;">
						<div style="margin-bottom: 10px;">
							<strong style="font-size: 14px;">Users</strong>
							<span style="margin-left: 15px; color: #666;">NodeBB Format: <code>/user/{username}</code></span>
						</div>
						<div style="margin-bottom: 8px;">
							<label style="font-weight: normal; margin-bottom: 3px;">Custom URL Pattern:</label>
							<input type="text" name="mapping_user" class="form-control" placeholder="/user/{username}" value="{mapping_user}">
						</div>
						<div style="background-color: #f5f5f5; padding: 8px; border-radius: 3px;">
							<small><strong>Available variables:</strong> <code>{userslug}</code> = username, <code>{uid}</code> = user_id</small>
							<br><small style="color: #666;"><strong>Example:</strong> <code>/profile/{userslug}</code> to change the path</small>
						</div>
					</div>

					<!-- Posts Section -->
					<div style="border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px;">
						<div style="margin-bottom: 10px;">
							<strong style="font-size: 14px;">Posts</strong>
							<span style="margin-left: 15px; color: #666;">NodeBB Format: <code>/post/{post_id}</code></span>
						</div>
						<div style="margin-bottom: 8px;">
							<label style="font-weight: normal; margin-bottom: 3px;">Custom URL Pattern:</label>
							<input type="text" name="mapping_post" class="form-control" placeholder="/post/{post_id}" value="{mapping_post}">
						</div>
						<div style="background-color: #f5f5f5; padding: 8px; border-radius: 3px;">
							<small><strong>Note:</strong> Simple path replacement only (no variable substitution)</small>
						</div>
					</div>

					<!-- Other Pages Section -->
					<div style="border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px;">
						<div style="margin-bottom: 10px;">
							<strong style="font-size: 14px;">Other Pages</strong>
							<span style="margin-left: 15px; color: #666;">Static paths (simple replacements)</span>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<label style="font-weight: normal; margin-bottom: 3px;">Notifications:</label>
								<input type="text" name="mapping_notifications" class="form-control" placeholder="/notifications" value="{mapping_notifications}" style="margin-bottom: 10px;">

								<label style="font-weight: normal; margin-bottom: 3px;">Unsubscribe:</label>
								<input type="text" name="mapping_unsubscribe" class="form-control" placeholder="/unsubscribe/" value="{mapping_unsubscribe}" style="margin-bottom: 10px;">

								<label style="font-weight: normal; margin-bottom: 3px;">Password Reset:</label>
								<input type="text" name="mapping_reset" class="form-control" placeholder="/reset/" value="{mapping_reset}" style="margin-bottom: 10px;">
							</div>
							<div class="col-sm-6">
								<label style="font-weight: normal; margin-bottom: 3px;">Registration:</label>
								<input type="text" name="mapping_register" class="form-control" placeholder="/register" value="{mapping_register}" style="margin-bottom: 10px;">

								<label style="font-weight: normal; margin-bottom: 3px;">Login:</label>
								<input type="text" name="mapping_login" class="form-control" placeholder="/login" value="{mapping_login}" style="margin-bottom: 10px;">

								<label style="font-weight: normal; margin-bottom: 3px;">Tags:</label>
								<input type="text" name="mapping_tags" class="form-control" placeholder="/tags/" value="{mapping_tags}" style="margin-bottom: 10px;">
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<label style="font-weight: normal; margin-bottom: 3px;">Groups:</label>
								<input type="text" name="mapping_groups" class="form-control" placeholder="/groups/" value="{mapping_groups}">
							</div>
						</div>
					</div>
				</div>
			</div>

			<button type="button" class="btn btn-primary" id="save">Save Settings</button>
		</form>
	</div>
</div>
