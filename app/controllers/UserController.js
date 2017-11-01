var express = require("express")
var bodyParser = require("body-parser")

var router = express.Router()

router.use(bodyParser.urlencoded({ extended: true }))

var User = require("../models/User")

router.get("/", function(req, res) {
	User.find({}, function(err, users) {
		if (err) 
			return res.status(500).send("There was a problem finding the users")
		res.status(200).send(users)
	})
});

// Get one user by id
router.get("/:id", function(req,res) {
	User.findById(req.params.id, function(err, user) {
		Console.log(user);
		if (err)
			return res.status(500).send("There was a problem finding the user")
		if (!user)
			return res.status(404).send("User not found!")
		res.status(200).send(user)
	})
});

// Updates a single user in the database
router.put("/:id", function(req, res) {
	Console.log(req);
	User.findByIdAndUpdate(req.params.id, req.body, { new: true }, function(err, user) {
		if (err) 
			return res.status(500).send("There was a problem updating the user.")
		res.status(200).send(user)
	})
});

// Deletes a user from the database
router.delete("/:id", function(req, res) {
	User.findByIdAndRemove(req.params.id, function(err, user) {
		if (err) 
			return res.status(500).send("There was a problem deleting the user.")
		res.status(200).send("User "+ user.name +" was deleted.")
	})
})

module.exports = router