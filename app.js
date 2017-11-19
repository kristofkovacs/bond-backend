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
var GoogleAuthController = require('./auth/google');

app.use('/user', UserController);
app.use('/category', CategoryController);
app.use('/event', EventController);
app.use('/auth', AuthController);
app.use('/google', GoogleAuthController);



// SWAGGER START
var argv = require('minimist')(process.argv.slice(2));
var subpath = express();
var swagger = require('swagger-node-express').createNew(subpath);

swagger.setApiInfo({
  title: "BOND API",
  description: "API to do serve the clients of our badass new product.",
  termsOfServiceUrl: "",
  contact: "bonderproject@gmail.com",
  license: "",
  licenseUrl: ""
});

app.get('/', function (req, res) {
  res.sendFile(__dirname + '/dist/index.html');
});

app.use("/v1", subpath);
app.use(express.static('dist'));

swagger.configureSwaggerPaths('', 'api-docs', '');

// Configure the API domain
var domain = '0.0.0.0';
//var domain = 'localhost';
if(argv.domain !== undefined)
    domain = argv.domain;
else
    console.log('No --domain=xxx specified, taking default hostname "localhost".')

// Configure the API port
var port = 8080;
if(argv.port !== undefined)
    port = argv.port;
else
    console.log('No --port=xxx specified, taking default port ' + port + '.')

// Set and display the application URL
var applicationUrl = 'http://' + domain + ':' + port;
console.log('snapJob API running on ' + applicationUrl);

swagger.configure(applicationUrl, '1.0.0');

// subpath.listen(port, function() {
//   console.log('Swagger listening on port ' + port);
// })

// SWAGGER END

app.listen(port, function() {
  console.log('Express server listening on port ' + port);
})

// require('./config/passport')(passport);

// require('./app/routes')(app, passport);
