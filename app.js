var express = require("express");
var config = require("./auth/config");
var session = require("express-session");
var passport = require("passport");
var bodyparser = require('body-parser');
var MemcachedStore = require("connect-memcached")(session);
var db = require("./config/db");
var morgan = require('morgan');

var app = express();
var port = process.env.port || 3000

app.use(bodyparser.urlencoded({extended: true}));
app.use(morgan('dev'));

app.use(session({ secret: 'kurvaanyjatennekaszarlogintemanak' }));
app.use(passport.initialize());
app.use(passport.session());

var UserController = require('./app/controllers/UserController');
var CategoryController = require('./app/controllers/CategoryController');
var EventController = require('./app/controllers/EventController');
var AuthController = require('./app/controllers/AuthController');

app.use('/user', UserController);
app.use('/category', CategoryController);
app.use('/event', EventController);
app.use('/auth', AuthController);

// require('./config/passport')(passport);

// require('./app/routes')(app, passport);

app.listen(port, function() {
  console.log('Express server listening on port ' + port)
})

// // Configure the session and session storage.
// var sessionConfig = {
// 	resave: false,
// 	saveUninitialized: false,
// 	secret: config.OAUTH2_CLIENT_SECRET,
// 	signed: true
// }

// // In production use the App Engine Memcache instance to store session data,
// // otherwise fallback to the default MemoryStore in development.
// if (config.NODE_ENV === "production" && config.MEMCACHE_URL) {
//   console.log("app -> config.node_env ...")
//   sessionConfig.store = new MemcachedStore({
// 		hosts: [config.MEMCACHE_URL]
// 	})
// }

// app.use(session(sessionConfig))

// module.exports = app;
