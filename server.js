require('coffee-script');
require('./lib/main');

// listen for user created event
require('./lib/firebase-listeners');

if(process.env.C9_PROJECT) process.env.NODE_ENV = 'test'