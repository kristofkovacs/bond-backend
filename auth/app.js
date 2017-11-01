// var express = require("express")
// var config = require("./config")
// var session = require("express-session")
// var MemcachedStore = require("connect-memcached")(session)
// var app = express()

// // Configure the session and session storage.
// var sessionConfig = {
// 	resave: false,
// 	saveUninitialized: false,
// 	secret: config.get("SECRET"),
// 	signed: true
// }

// // In production use the App Engine Memcache instance to store session data,
// // otherwise fallback to the default MemoryStore in development.
// if (config.get("NODE_ENV") === "production" && config.get("MEMCACHE_URL")) {
// 	sessionConfig.store = new MemcachedStore({
// 		hosts: [config.get("MEMCACHE_URL")]
// 	})
// }

// app.use(session(sessionConfig))

// module.exports = app