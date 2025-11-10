define('admin/plugins/custom-email-urls', ['settings', 'alerts'], function (Settings, alerts) {
	'use strict';

	var ACP = {};

	ACP.init = function () {
		Settings.load('custom-email-urls', $('.custom-email-urls-settings'));

		$('#save').on('click', function () {
			Settings.save('custom-email-urls', $('.custom-email-urls-settings'), function (err) {
				if (err) {
					return alerts.error(err.message || err);
				}
				alerts.success('Settings saved successfully!');
			});
		});
	};

	return ACP;
});
