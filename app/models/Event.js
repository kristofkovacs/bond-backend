var mongoose = require("mongoose")

var EventSchema = mongoose.Schema({
  creator_id: String,
	category: { 
    _id: String,
    name: String,
    thumbnail_url: String
  },
  //location_id: String,
	date: String,
	time: String,
	attendees_count: Number,
	max_attendees: Number,
})

mongoose.model("Event", EventSchema)

module.exports = mongoose.model("Event")