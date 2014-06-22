// server.js

// BASE SETUP
// =============================================================================

// call the packages we need
var express    = require('express');        // call express
var app        = express();                 // define our app using express
var bodyParser = require('body-parser');
var crypto = require('crypto');

var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('database.db');

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
	var startDate = req.header('Start-Date');
	var endDate = req.header('End-Date');

	if(startDate && endDate) {
		var jsonResult = '[';	
		db.each("select temperature, timestamp from temperature where timestamp between '"+startDate+"' and '"+endDate+"' order by timestamp", function(err,row) {
			jsonResult += '{ value: '+row.temperature +', timestamp: '+ row.timestamp+'},'; 
		},function(err,row) {
			jsonResult = jsonResult.substring(0,jsonResult.length-1);
			jsonResult +=']';
			res.json(jsonResult);
		});

		//console.log(jsonResult);
		//res.json(jsonResult);
	} else {
	db.each("select temperature, timestamp from temperature order by timestamp desc limit 1", function (err, row) {
	   res.json({value: row.temperature, timestamp:row.timestamp});
	});
	}
       // res.json({value: "23"}); //TODO here paste some logic
    });

router.route('/temperature/:back_record_number')
    // get latest record of temperature (accessed at GET http://localhost:8080/api/temperature/2)
    .get(function(req, res) {
        checkHash(req, res);
	db.each("select temperature, timestamp from temperature order by timestamp desc limit "+ req.params.back_record_number+",1", function(err,row) {
	  res.json({value: row.temperature, timestamp: row.timestamp});
	});
       // res.json({value:18, timestamp: (new Date()).getTime()}); //TODO here paste some logic
    });
// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic happens on port ' + port);
