var express = require("express")
var bodyParser = require("body-parser")

var router = express.Router()

router.use(bodyParser.urlencoded({ extended: true }))

router.post('/login', function(req, res) {
  User.findOne({email: req.body.email} , function(err, user) {
    if (err)
      return res.status(500).send('There was a problem while logging in!');
    if (!user)
      return res.status(404).send('User with this email does not exist. Please sign up!')
    if (req.body.password != user.password)
      return res.status(401).send('Wrong password')
    res.status(200).send(user)
  })  
})

router.post('/sign-up', function(req, res) {
  User.findOne({email: req.body.email}, function(err, user) {
    if (err)
      return res.status(500).send('There was a problem while singing up!');
    if (user)
      return res.status(400).send('User already exists, please log in!');
    User.create({
      name: req.body.name,
      email: req.body.email,
      password: req.body.password
    }, function(err, user) {
      if (err)
        return res.status(500).send('There was a problem while creating the user!');
      res.status(200).send(user);
    })
  })
})

module.exports = router;


