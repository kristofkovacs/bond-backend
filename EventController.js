var express = require("express")
var bodyParser = require("body-parser")

var router = express.Router()

router.use(bodyParser.urlencoded({ extended: true }))

var Event = require("./Event")

// Get all events
router.get("/", function(req, res) {
	Event.find({}, function(err, events) {
		if (err)
			return res.status(500).send("Error while getting events: " + err)
		res.status(200).send(events)
	})
})

router.get("/:id", function(req, res) {
	Event.findById(req.params.id), function(err, event) {
		if (err)
			return res.status(500).send("Error while fetching event: " + err)
		if (!event)
			return res.status(404).send("Event with id: " + req.params.id + "not found.")
		res.status(200).send(event)
	}
})

// Post an event
router.post("/", function(req, res) {
	Event.create({
		creator_id: req.body.creator_id,
		category: { 
			name: req.body.category.name,
			thumbnail_url: req.body.category.thumbnail_url
		},
		date: req.body.date,
		time: req.body.time,
		attendees_count: req.body.attendees_count,
		max_attendees: req.body.max_attendees
	}, function(err, event) {
		if (err)
			return res.status(500).send("Error while creating event: " + err)
		res.status(200).send(event)
	})
})

module.exports = router
