var express = require("express");
var config = require("./config");
var authConfig = require('./auth');
var bodyParser = require("body-parser");

var GoogleStrategy = require('passport-google-oauth20').Strategy;
var passport = require('passport');

var User = require('../app/models/User');

var router = express.Router();
router.use(bodyParser.json());

passport.serializeUser((user, cb) => {
  cb(null, user);
});
passport.deserializeUser((obj, cb) => {
  cb(null, obj);
});

passport.use(new GoogleStrategy({
  clientID        : authConfig.googleAuth.clientID,
  clientSecret    : authConfig.googleAuth.clientSecret,
  callbackURL     : authConfig.googleAuth.callbackURL,
  }, function() {
    Console.log('ide bejon');
  },
  function(accessToken, refreshToken, profile, cb) {
    console.log(profile);
    process.nextTick(function() {
      User.findOne({ 'google.id': profile.id }, function(err, user) {
        if (err)
          return cb(err);
        if (user) {
          return cb(null, user);
        } else {
          var newUser = new User();
          newUser.google.id = profile.id;
          newUser.google.accessToken = profile.accessToken;
          newUser.google.refreshToken = profile.refreshToken;
          newUser.google.name = profile.displayName;
          newUser.google.email = profile.email;
  
          newUser.save(function(err) {
            if (err)
              return(err, null)
            return cb(null, newUser);
          })
        }
      })
    })
  }
));

router.get('/auth/google', 
  (req, res, next) => {
    if (req.query.return) {
      req.session.oauth2return = req.query.return;
    }
    next();
  },
  passport.authenticate('google', { scope: ['email', 'profile'] })
);

router.get('/auth/google/callback', 
passport.authenticate('google', { failureRedirect: '/login' }),
function(req, res) {
  // Successful authentication, redirect home.
  Console.log('callback')
  const redirect = req.session.oauth2return || '/';
  delete req.session.oauth2return;
  res.redirect(redirect);
  
  
  // res.send(req.user ? 200 : 401);
});

module.exports = {
	router: router
}