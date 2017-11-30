var express = require("express");
var bodyParser = require("body-parser");

var router = express.Router();

router.use(bodyParser.json());

var Category = require("../models/Category");
var ActivityModel = require('../models/Activity');

// Get all categories
router.get("/", function(req, res) {
	Category.
		find({}).
		populate('activities').
		exec(function(err, categories) {
			if (err)
				return res.status(500).send('There was a problem finding the categories.');
			res.status(200).send(categories);
	});
});

// Get a category by id
router.get("/:id", function(req, res) {
	Category.
		findById(req.params.id).
		populate('activities').
		exec(function(err, category) {
			if (err)
				return res.status(500).send("There was a problem finding the category.");
			if (!category)
				return res.status(404).send("Category not found");
			return res.status(200).send(category)
		});
});

// Post a category
router.post("/", function(req, res) {
  var myActivities = new Array();

	Category.create({
    name: req.body.name
  }, function(err, category) {
    if (err)
      return res.status(500).send("Error while adding the category:" + err);
    var activities = req.body.activities;

		for(var i = 0; i < activities.length; i++) {
      var activity = activities[i];
      ActivityModel.create({
          name: activity.name,
          category: category._id
        },
        function (err, newActivity) {
          if (err)
            return res.status(500).send("Error while adding the activity:" + err);
          myActivities.push(newActivity);

          if (myActivities.length == activities.length) {
            category.activities = myActivities;
						category.save();
            return res.status(200).send(category);
          }
        });
    }
  });

});

router.delete('/all', function(req, res) {
  Category.remove({}, function(err) {
    res.status(200).send('Delete successfull');
  })
});

router.delete("/:id", function(req, res) {
	Category.findByIdAndRemove(req.params.id, function(err, category) {
		if (err) 
			return res.status(500).send("There was a problem deleting the category.");
		res.status(200).send("Category "+ category.name +" was deleted.")
	})
});



module.exports = router;