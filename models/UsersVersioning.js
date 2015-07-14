var errorCodes = require(ROOT_DIR + 'config/error'),
Checkit  = require('checkit');

var UsersVersioning = dbObj.Model.extend({
	tableName: 'wa_user_versioning',
	idAttribute: 'id',

	setDeviceInfo : function(callback, deviceInfo) {

		dbObj.knex.raw("Update wa_user_versioning SET status = 2,active_till = localtimestamp where imei = '" + deviceInfo.imei + "' AND status = 1")
		.then(function (dataExists) {

			new UsersVersioning({
				user_id          : deviceInfo.user_id,
				api_app_id       : deviceInfo.api_app_id,
				device           : deviceInfo.device,
				platform         : deviceInfo.platform,
				platform_version : deviceInfo.platform_version,
				imei             : deviceInfo.imei
			})
			.save()
			.then(function(result) {
				callback(result);
			})
			.catch(function(err) {
				callback(errorCodes.error_403.server_error);
			})
		})
		.catch(function(err) {
			callback(errorCodes.error_403.server_error);
		});
	},

	checkDeviceInfo : function(callback, deviceInfo) {

		new UsersVersioning({user_id : deviceInfo.user_id,
			imei    : deviceInfo.imei,
			status  : 1
		})
		.fetch()
		.then(function (dataExists) {

			if(dataExists)
				callback(1);
			else
			{
				dbObj.knex.raw("Update wa_user_versioning SET status = 2,active_till = localtimestamp where user_id = '" + deviceInfo.user_id + "' AND status = 1")
				.then(function (dataExists) {

					new UsersVersioning().setDeviceInfo(function(deviceRes) {
						callback(deviceRes);
					}, deviceInfo);
				})
				.catch(function(err) {
					callback(errorCodes.error_403.server_error);
				});

			}
		})
		.catch(function(err) {
			callback(errorCodes.error_403.server_error);
		});
	},

	registerDevice :  function(callback, params, accessToken) {

		var checkit = new Checkit ({
			user_id :[
				{
					rule    : 'required',
					message : 'User Id required'
				},
				{
					rule    : 'integer',
					message : 'User Id should be numeric'
				}],
			register_id :
				{
					rule    : 'required',
					message : 'register id required'
				}
		});

		var body = {
			user_id : params.user_id,
			register_id   : params.register_id
		};

		checkit.run(body).then(function(validated) {

			var oauthUserObj = require(ROOT_DIR + "models/OauthUsers").createObj();

			oauthUserObj.checkAccessToken( function(result) {

				if(result.error_code)
					callback(result);
				else
				{
					new UsersVersioning({
                        user_id      : params.user_id,
                        status    	 : 1
                    })
                    .fetch({require: true})
                    .then(function(user) {
                        user.save({ registered_id : params.register_id })
						.then(function(result) {
							var actResp = {};
                            	actResp.status = 'success';
                            	actResp.message = 'Action performed successfully';
                            callback(actResp);
						})
						.catch(function(err) {
							callback(errorCodes.error_403.server_error);
						});
					})
					.catch(function(err) {
						callback(errorCodes.error_403.server_error);
					});
				}
			}, params.user_id, accessToken);
		})
		.catch(Checkit.Error, function(err) {

			var error = errorCodes.error_400.custom_invalid_params;
			error.responseParams.message = err.toJSON();
			callback(error);
		});
	}
});

module.exports.createObj = function()
{
	return new UsersVersioning();
}