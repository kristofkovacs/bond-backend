var mongoose = require("mongoose")

var EventSchema = mongoose.Schema({
  creator_id: String,
	category_id: String,
  attendees: [String],
  is_private: Boolean,
  location: {
    lat: Number,
    lon: Number
  },
  address: String,
  date_created: Number,
  date_modified: Number,
  date_begin: Number,
  attendees_count: Number,
	attendees_min: Number,
  attendees_max: Number
})

mongoose.model("Event", EventSchema)

module.exports = mongoose.model("Event")