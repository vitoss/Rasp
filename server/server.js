// server.js

// BASE SETUP
// =============================================================================

// call the packages we need
var express    = require('express');        // call express
var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
var crypto = require('crypto');

var CRYPTO_KEY = '9086229259';

var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'salt, hash');

    next();
}

var checkHash = function(req, res) {
    //calculate security hash
    var givenHash = req.headers.hash;
    var calculatedHash = crypto.createHash('md5').update(CRYPTO_KEY + req.headers.salt + CRYPTO_KEY).digest('hex');

    if(givenHash != calculatedHash) {
        console.log('Permission denied. Hashes do not match.');
        console.log('Expected: ' + calculatedHash + ' given ' + givenHash);
        res.send(401);
    }
}

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser());

app.use(allowCrossDomain);

var port = process.env.PORT || 8080;        // set our port

// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();              // get an instance of the express Router

// middleware to use for all requests
router.use(function(req, res, next) {
    // do logging
    console.log('Something is happening.');
    console.log(req.headers);

    next(); // make sure we go to the next routes and don't stop here
});

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our Raspberry api!' });
});

router.route('/temperature')
    // get latest record of temperature (accessed at GET http://localhost:8080/api/temperature)
    .get(function(req, res) {
        checkHash(req, res);
        res.json({value: "23"}); //TODO here paste some logic
    });

router.route('/temperature/:back_record_number')
    // get latest record of temperature (accessed at GET http://localhost:8080/api/temperature/2)
    .get(function(req, res) {
        checkHash(req, res);
        res.json({value:18, timestamp: (new Date()).getTime()}); //TODO here paste some logic
    });
// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic happens on port ' + port);
