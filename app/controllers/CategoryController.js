var express = require("express")
var bodyParser = require("body-parser")

var router = express.Router()

router.use(bodyParser.json())

var Category = require("../models/Category")

// Get all categories
router.get("/", function(req, res) {
	Category.find({}, function(err, categories) {
		if (err)
			return res.status(500).send("There was a problem finding the categories.")
		return res.status(200).send(categories)
	})
})

// Get a category by id
router.get("/:id", function(req, res) {
	Category.findById(req.params.id, function(err, category) {
		if (err)
			return res.status(500).send("There was a problem finding the category.")
		if (!category)
			return res.status(404).send("Category not found")
		return res.status(200).send(category)
	})
})

// TODO: what if the category already exists? Should names be unique?
// Post a category
router.post("/", function(req, res) {
	Category.create({
		name: req.body.name,
		thumbnail_url: req.body.thumbnail_url
	},
	function(err, category) {
		if (err)
			return res.status(500).send("Error while adding the category:" + err)
		res.status(200).send(category)
	})
})

router.delete("/:id", function(req, res) {
	Category.findByIdAndRemove(req.params.id, function(err, category) {
		if (err) 
			return res.status(500).send("There was a problem deleting the category.")
		res.status(200).send("Category "+ category.name +" was deleted.")
	})
})

module.exports = router