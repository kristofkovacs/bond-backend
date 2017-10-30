var mongoose = require("mongoose")

var CategorySchema = mongoose.Schema({
	name: String,
	thumbnail_url: String
})

mongoose.model("Category", CategorySchema)

module.exports = mongoose.model("Category")