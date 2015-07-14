var promise = require('bluebird');
var errorCodes = require(ROOT_DIR + 'config/error');

var apiAppVersion = dbObj.Model.extend({
	tableName: 'wa_api_app_versions',
	idAttribute: 'id',

	/********Function to get api version corressponding to app version*******/
	getApiVersion : function(callback, params, secretKey ) {

		var oauthClientObj = require(ROOT_DIR + "models/OauthClients").createObj();

		if(params.app_version && params.platform)
		{
			oauthClientObj.getSecretKey( function(result) {
				if(result.error_code)
					callback(result); // send error information
				else
				{
					new apiAppVersion({ 'app_version' : params.app_version,'platform' : params.platform.toUpperCase() })
					.fetch()
					.then(function (api) {
						callback(api.get('api_version'));
					})
					.catch(function(err) {
						console.log(err);
						callback(errorCodes.error_403.server_error);
					});
				}
			}, secretKey);
		}
		else
			callback(errorCodes.error_400.invalid_params);
	}
	/****************************End of function*******************************/
});

module.exports.createObj = function()
{
	return new apiAppVersion();
}