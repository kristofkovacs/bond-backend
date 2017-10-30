// This file will be used for configuring the app, and that alone.
// All of the logic will be put in its respective directory regarding
// the specific feature it will be implementing.

var express = require("express")
var config = require("./auth/config")
var session = require("express-session")
var passport = require("passport")
var MemcachedStore = require("connect-memcached")(session)
var db = require("./db")

var app = express()

var UserController = require("./UserController")
var CategoryController = require("./CategoryController")
var EventController = require("./EventController")

app.use(passport.initialize())
app.use(passport.session())
app.use(require("./auth/google").router)

app.use("/users", UserController)
app.use("/category", CategoryController)
app.use("/events", EventController)

// Configure the session and session storage.
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

module.exports = app
