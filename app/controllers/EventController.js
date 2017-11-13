var express = require("express")
var bodyParser = require("body-parser")

var router = express.Router()

router.use(bodyParser.json())

var EventModel = require("../models/Event")

// Get all events
router.get("/", function(req, res) {
	EventModel.find({}, function(err, events) {
		if (err)
			return res.status(500).send("Error while getting events: " + err)
		res.status(200).send(events)
	})
})

router.get("/:id", function(req, res) {
	console.log(req.param.id);
	EventModel.findById(req.params.id), function(err, event) {
		console.log(req.param.id)
		if (err)
			return res.status(500).send("Error while fetching event: " + err)
		if (!event)
			return res.status(404).send("Event with id: " + req.params.id + "not found.")
		res.status(200).send(event)
	}
})

// Post an event
// router.post("/", function(req, res) {
// 	Event.create({
// 		creator_id: req.body.creator_id,
// 		category: { 
// 			name: req.body.category.name,
// 			thumbnail_url: req.body.category.thumbnail_url
// 		},
// 		date: req.body.date,
// 		time: req.body.time,
// 		attendees_count: req.body.attendees_count,
// 		max_attendees: req.body.max_attendees
// 	}, function(err, event) {
// 		if (err)
// 			return res.status(500).send("Error while creating event: " + err)
// 		res.status(200).send(event)
// 	})
// })

router.post('/', function(req, res) {
	var reqEvents = req.body;
	var resEvents = [];
	var eventsProcessed = 0;
	
	reqEvents.forEach(function(reqEvent) {
		EventModel.create({
			creator_id: reqEvent.creator_id,
			category: { 
				_id: reqEvent._id,
				name: reqEvent.category.name,
				thumbnail_url: reqEvent.category.thumbnail_url
			},
			date: reqEvent.date,
			time: reqEvent.time,
			attendees_count: reqEvent.attendees_count,
			max_attendees: reqEvent.max_attendees
		}, function(err, event) {
			if (err)
				return res.status(500).send("Error while creating event: " + err)
			eventsProcessed++;
			resEvents.push(event);
			if (eventsProcessed === reqEvents.length) {
				return res.status(200).send(resEvents)
			}
		})
	}, this);
})

router.delete("/:id", function(req, res) {
	EventModel.findByIdAndRemove(req.params.id, function(err, event) {
		if (err) 
			return res.status(500).send("There was a problem deleting the event.")
		res.status(200).send("Event "+ event.id +" was deleted.")
	})
})

module.exports = router
