#!/bin/env node
// WebSocket example based on template:
//  OpenShift sample Node application
var server = require('http').createServer()
var express  = require('express');
var fs       = require('fs');
var swig     = require('swig');
var app      = express();
var url	     = require('url')

var WebSocketServer = require("ws").Server
var wss = new WebSocketServer({ server: server })

/**
 *  Define the sample application.
 */
var WebSocketApp = function() {

    //  Scope.
    var self = this;


    /*  ================================================================  */
    /*  Helper functions.                                                 */
    /*  ================================================================  */

    /**
     *  Set up server IP address and port # using env variables/defaults.
     */
    self.setupVariables = function() {
	self.cfg = {};
	self.cfg.bootstrap_dir = 'bootstrap-3.3.6';
	self.cfg.jquery_dir    = 'jquery-1.3.1';
	self.cfg.min_suffix    =  '.min'; // '.min' for debug of css/js


        //  Set the environment variables we need.
        self.ipaddress = process.env.OPENSHIFT_NODEJS_IP;
        self.port      = process.env.OPENSHIFT_NODEJS_PORT || 5000;
	self.cfg.isOpenShift = false;

        if (typeof self.ipaddress === "undefined") {
            //  Log errors on OpenShift but continue w/ 127.0.0.1 - this
            //  allows us to run/test the app locally.
            console.warn('No OPENSHIFT_NODEJS_IP var, using 127.0.0.1');
            self.ipaddress = "127.0.0.1";
        } else {
	    self.cfg.isOpenShift = true;
	    console.log('%s: OpenShift rutnime detected',Date(Date.now()));
	};
    };

    /**
     *  terminator === the termination handler
     *  Terminate server on receipt of the specified signal.
     *  @param {string} sig  Signal to terminate on.
     */
    self.terminator = function(sig){
        if (typeof sig === "string") {
           console.log('%s: Received %s - terminating sample app ...',
                       Date(Date.now()), sig);
           process.exit(1);
        }
        console.log('%s: Node server stopped.', Date(Date.now()) );
    };


    /**
     *  Setup termination handlers (for exit and a list of signals).
     */
    self.setupTerminationHandlers = function(){
        //  Process on exit and signals.
        process.on('exit', function() { self.terminator(); });

        // Removed 'SIGPIPE' from the list - bugz 852598.
        ['SIGHUP', 'SIGINT', 'SIGQUIT', 'SIGILL', 'SIGTRAP', 'SIGABRT',
         'SIGBUS', 'SIGFPE', 'SIGUSR1', 'SIGSEGV', 'SIGUSR2', 'SIGTERM'
        ].forEach(function(element, index, array) {
            process.on(element, function() { self.terminator(element); });
        });
    };


    /*  ================================================================  */
    /*  App server functions (main app logic here).                       */
    /*  ================================================================  */

    /**
     *  Initialize the server (express) and create the routes and register
     *  the handlers.
     */
    self.initializeServer = function() {
        self.app = app;
	self.app.use ( express.static('public') );
        // console.log('swig '+JSON.stringify(swig,null,4));
        self.app.engine('swig', swig.renderFile);
        self.app.set('view engine', 'swig');

	self.app.get('/',function(req,res){
		res.render('index', {
			cfg: self.cfg,
			title: 'WebSockets sample  '+new Date().toDateString()
			      +' ('+( self.cfg.isOpenShift ? 'OpenShift'
								: 'standalone')
			      +')'
		});
	});

	self.wss = wss;

	self.wss.on('connection', function connection(ws) {
		// does not work...
		// var location = url.parse(ws.upgradeReq.url, true);
		var id = setInterval(function() {
			var data = JSON.stringify(new Date());
			// console.log('sending data ...'+data);
			ws.send(data, function() {  })
		}, 1000);
		console.log("websocket connection open")


		ws.on('message', function incoming(message) {
		    console.log('received: %s', message);
		});

		ws.on("close", function() {
			console.log("websocket connection close")
			clearInterval(id)
		});
	});
    };


    /**
     *  Initializes the sample application.
     */
    self.initialize = function() {
        self.setupVariables();
        self.setupTerminationHandlers();

        // Create the express server and routes.
        self.initializeServer();
    };


    /**
     *  Start the server (starts up the sample application).
     */
    self.start = function() {
	server.on('request',self.app)
        //  Start the app on the specific interface (and port).
        server.listen(self.port, self.ipaddress, function() {
            console.log('%s: Node server started on %s:%d ...',
                        Date(Date.now() ), self.ipaddress, self.port);
        });
    };

};   /*  Web Socket Application.  */



/**
 *  main():  Main code.
 */
var zapp = new WebSocketApp();
zapp.initialize();
zapp.start();

