//var Schema = mongooseObj.Schema;
var mySchema = mongooseObj.Schema({
    name: String,
    contact_no: Number,
    email: mongooseObj.Schema.Types.Mixed
});

// db is global
//module.exports = mongoseObj.model('MyModel', mySchema);
var myModel = mongooseObj.model('testschma', mySchema);

exports.fetch = function(callback) {
    myModel.find({}, function (err, docs) {
        console.log('====err===');
        console.log(err);
        console.log('====res====');
        console.log(docs);
        callback(docs);
    });
};

exports.insert = function(callback, params){
    console.log(params);
    myModel.create({ name: params.name, contact_no: params.contact_no,email: params.email }, function (err, doc) {
        if (err) console.log(err);
        callback(doc);
    })
};