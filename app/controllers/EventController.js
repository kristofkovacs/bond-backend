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

router.post('/', function(req, res) {
	var reqEvents = req.body;
	var resEvents = [];
	var eventsProcessed = 0;

	if (reqEvents instanceof Array) {
    reqEvents.forEach(function(reqEvent) {
      EventModel.create({
        creator_id: reqEvent.creator_id,
        category_id: reqEvent.category_id,
        attendees: [reqEvent.creator_id],
        is_private: Boolean,
        location: {
          lat: reqEvent.location.lat,
          lon: reqEvent.location.lon
        },
        address: reqEvent.address,
        date_created: new Date().getTime(),
        date_modified: new Date().getTime(),
        date_begin: reqEvent.date_begin,
        attendees_count: 1,
        attendees_min: reqEvent.attendees_min,
        attendees_max: reqEvent.attendees_max
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
	} else {
    EventModel.create({
      creator_id: reqEvents.creator_id,
      category_id: reqEvents.category_id,
      attendees: [reqEvents.creator_id],
      is_private: false,
      location: {
        lat: reqEvents.location.lat,
        lon: reqEvents.location.lon
      },
      address: reqEvents.address,
      date_created: new Date().getTime(),
      date_modified: new Date().getTime(),
      date_begin: reqEvents.date_begin,
      attendees_count: 1,
      attendees_min: reqEvents.attendees_min,
      attendees_max: reqEvents.attendees_max
    }, function(err, event) {
      if (err)
        return res.status(500).send("Error while creating event: " + err);
			return res.status(200).send(event);
    })
	}


});

router.delete("/:id", function(req, res) {
	EventModel.findByIdAndRemove(req.params.id, function(err, event) {
		if (err) 
			return res.status(500).send("There was a problem deleting the event.")
		res.status(200).send("Event "+ event.id +" was deleted.")
	})
})

router.delete("/", function(req, res) {
	EventModel.remove({}, function(err, num) {
		console.log("removed" + num + "events");
	})
});

module.exports = router
