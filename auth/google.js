var express = require("express");
var config = require("./config");
var authConfig = require('./auth');
var bodyParser = require("body-parser");

var GoogleStrategy = require( 'passport-google-oauth2' ).Strategy;
var passport = require('passport');

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});

passport.use(new GoogleStrategy({
  clientID        : authConfig.googleAuth.clientID,
  clientSecret    : authConfig.googleAuth.clientSecret,
  callbackURL     : authConfig.googleAuth.callbackURL,
  passReqToCallback   : true
},
function(request, accessToken, refreshToken, profile, done) {
  // var post = { name: profile.name, email: profile.email }
  return done(err, profile);
  // User.findOrCreate({ googleId: profile.id }, function (err, user) {
  //   return done(err, user);
  // });
}));

var router = express.Router();
router.use(bodyParser.json());

router.get('/auth/google',
passport.authenticate('google', { scope:
  [ 'https://www.googleapis.com/auth/plus.login',
    'https://www.googleapis.com/auth/plus.profile.emails.read' ] }
, function(){
  console.log('kutyacica');
}));

router.get( '/auth/google/callback',
passport.authenticate( 'google', {
  successRedirect: '/auth/google/success',
  failureRedirect: '/auth/google/failure'
}, function(){
  console.log('cicakutya');
}));



// var GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;
// var passport = require('passport');

// passport.use(new GoogleStrategy({
//     clientID        : authConfig.googleAuth.clientID,
//     clientSecret    : authConfig.googleAuth.clientSecret,
//     callbackURL     : authConfig.googleAuth.callbackURL,  
//   },
//   function(token, refreshToken, profile, done) {
//     process.nextTick(function() {
//       var post = {name: profile.displayName, email: profile.emails[0].value, token: ""} ;
//       console.log(post);
//       return done(null, post);    
//     })
// }
// ));

// var router = express.Router()
// router.post("/auth/google",
//   passport.authenticate("google",function(a,b,c,d) {
//       console.log(a,b,c,d);
//   }),
// 	function (req, res) {
//     // do something with req.user 
//     console.log(req.body)
//     console.log("post /auth/google callback")
// 		res.send(req.user? 200 : 401)
// 	}
// )


// [START setup]
// var passport = require("passport")
// // var GoogleStrategy = require("passport-google-id-token")
// console.log("google.js passport.use elott")

// var GoogleTokenStrategy = require("passport-google-id-token")

// var GOOGLE_CLIENT_ID = "665026689829-vml6f8aveu0asln87pi4ug3uc63bq3f7.apps.googleusercontent.com"
// var GOOGLE_CLIENT_SECRET = "DrmRm03NDbTSygdF2aA0Mej9"

// var router = express.Router()
// router.use(bodyParser.json())
// passport.use(bodyParser.json())

// passport.use('google-id-token', new GoogleTokenStrategy({
//   clientID: GOOGLE_CLIENT_ID,
//     audience: config.audience
//     //clientSecret: GOOGLE_CLIENT_SECRET
//     //getGoogleCerts: optionalCustomGetGoogleCerts
//   },
//   function(parsedToken, googleId, done) {
//     var user = parsedToken.payload
//     console.log(parsedToken)
//     var post = {name: user.name, email: user.email, token: ""}
//     console.log(googleId)
//     return done(null, post)
//     // User.findOrCreate({ googleId: googleId }, function (err, user) {
//     // 	return done(err, user)
//     //  })
//   }
//   )
// )


// router.post("/auth/google",
//   passport.authenticate("google-id-token",function(a,b,c,d) {
//       console.log(a,b,c,d);
//   }),
// 	function (req, res) {
//     // do something with req.user 
//     console.log(req.body)
//     console.log("post /auth/google callback")
// 		res.send(req.user? 200 : 401)
// 	}
// )


// passport.use("google-id-token", new GoogleStrategy({
// 	clientID: config.OAUTH2_CLIENT_ID,
// 	clientSecret: config.OAUTH2_CLIENT_SECRET,
// 	callbackURL: config.OAUTH2_CALLBACK,
// },
// function (parsedToken, googleId, done) {
// 	var user = parsedToken.payload
// 	console.log(parsedToken)
// 	var post = {name: user.name, email: user.email, token: ""}
// 	console.log(googleId)
// 	return done(null, post)
// 	// addUser(post, function (err, data) {
// 	// 	if (err)
// 	// 		;
// 	// 	else {
// 	// 		// var token = generateTokenSocial(data)
// 	// 		// post.token = token
// 	// 		return done(null, post)
// 	// 	}
// 	// })
// }
// ))

// router.post("/auth/google",
// 	passport.authenticate("google-id-token"),
// 	function (req, res) {
// 		// do something with req.user
// 		console.log("google-id-token")
// 		var user = req.user
// 		console.log(user)
// 		// res.json(user)
// 		res.send(req.user? 200 : 401)
// 	}
// )

module.exports = {
	router: router
}