var winston = require('winston'),
connection,
pg = require('pg');

if(process.argv[2])
	var dbjson = require('./' + process.argv[2] + '.json');
else
	var dbjson = require('./local.json');

var logger = new (winston.Logger)({
	transports: [
	new winston.transports.File({ filename: ROOT_DIR + 'config/debug.log', json: false })
	],
	exceptionHandlers: [
	new winston.transports.File({ filename: ROOT_DIR + 'config/exceptions.log', json: false })
	],
	exitOnError: false
});

module.exports = logger;

module.exports.postgres_init_master = function(){
		//var client = new pg.Client(dbjson.master);
		//return client;

	var knex = require('knex')({
		client: 'pg',
		connection: dbjson.postgres.master,
		pool: {
			min: 0,
			max: 7
		}
	});

	var bookshelf = require('bookshelf')(knex);
	return bookshelf;
};

module.exports.postgres_init_slave = function(){
	// var client = new pg.Client(dbjson.slave);
	// return client;

	var knex = require('knex')({
		client: 'pg',
		connection: dbjson.postgres.slave,
		pool: {
			min: 0,
			max: 7
		}
	});

	var bookshelf = require('bookshelf')(knex);
	return bookshelf;
};

module.exports.mongo_init_master = function(){

	var mongoose = require('mongoose');
	return mongoose.connect(dbjson.mongo.master);
};