var mongoose = require("mongoose");
var activity = require('./Activity');

var CategorySchema = mongoose.Schema({
	name: String,
	activities: [ { type: mongoose.Schema.Types.ObjectId, ref: 'Activity'} ]
});

mongoose.model("Category", CategorySchema);

module.exports = mongoose.model("Category");