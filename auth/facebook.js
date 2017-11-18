var express = require("express");
var config = require("./config");
var authConfig = require('../config/auth');
var bodyParser = require("body-parser");
var jwt = require('jsonwebtoken');
var expressJwt = require('express-jwt');
var cors = require('cors');

var FacebookStrategy = require('passport-facebook-token');
var passport = require('passport');

var User = require('../app/models/User');

var router = express.Router();

FACEBOOK_APP_ID = '1137516069715797';
FACEBOOK_APP_SECRET = 'e8d855c9e712b19dedf33cde6b27f1c1';


router.use(passport.initialize());
router.use(passport.session());

passport.serializeUser(function (user, done) {
    done(null, user);
});

passport.deserializeUser(function (user, done) {
    done(null, user);
});


passport.use(new FacebookTokenStrategy({
    clientID: FACEBOOK_APP_ID,
    clientSecret: FACEBOOK_APP_SECRET
  },
  function (accessToken, refreshToken, profile, done) {
    User.upsertFbUser(accessToken, refreshToken, profile, function(err, user) {
      return done(err, user);
    });
}));

module.exports = router


