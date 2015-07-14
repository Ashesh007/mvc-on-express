var express = require('express'),
fs = require('fs'),
path = require('path'),
routes = require('json-routing'),
apiv = require('api-version'),
apiDom = express(),
webDom = express();

module.exports = function()
{
	apiDom.set('views', './views');
	apiDom.set('view engine', 'jade');

	webDom.set('views', './views');
	webDom.set('view engine', 'jade');

	var routeOptions = {
		routesPath      : "./routes/API",
		controllerPath  : "./controllers",
		//policyPath      : "./policy"
	};
	routes(apiDom, routeOptions);

	/******************api-versioning*********************/
	var apiDomV1 = apiv.version(apiDom, '/v1'),
	apiDomV2 = apiv.version(apiDom, '/v2');

	var routeOptionsV1 = {
		routesPath      : "./routes/API/v1",
		controllerPath  : "./controllers",
		//policyPath      : "./policy"
	};
	routes(apiDomV1, routeOptionsV1);

	var routeOptionsV2 = {
		routesPath      : "./routes/API/v2",
		controllerPath  : "./controllers",
		//policyPath      : "./policy"
	};
	routes(apiDomV2, routeOptionsV2);
	/*****************************************************/

	var wrouteOptions = {
		routesPath      : "./routes/web_routes",
		controllerPath  : "./controllers",
		//policyPath      : "./policy"
	};
	routes(webDom, wrouteOptions);

	var domains = {
		'domains' : [
		{ 'domain_name' : 'api.mvc-on-express.com', 'object' : apiDom },
		{ 'domain_name' : 'mvc-on-express.com', 'object' : webDom }
		]
	};

	return domains;
}