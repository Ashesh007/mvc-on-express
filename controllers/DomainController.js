exports.apiDom = function(req,res) {
	res.json('Bhai api domain hai');
};

exports.webDom = function(req,res) {
	res.json('Darling web domain hai');
};

exports.showV1 = function(req,res) {
	res.send('Its api version 1');
};

exports.showV2 = function(req,res) {
	res.send('Its api version 2');
};

exports.apiVersion = function(req,res) {

	var ApiVersionModel = require(ROOT_DIR + "models/ApiAppVersion" ).createObj();

	ApiVersionModel.getApiVersion(function(result) {

		if(result.error_code)
		{
			res.set({'error_code' : result.error_code});
			res.status(result.responseHeaders.status).json(result.responseParams);
		}
		else
			res.json({'api_version' : result});

	},req.params, req.headers.secret_key);
};