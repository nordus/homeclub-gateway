var trans = require('coffee-script');
if (trans.register) {
  trans.register();
}
var dgram   = require('dgram');
var decode  = require('./lib/decode');

var server  = dgram.createSocket('udp4', decode);

server.on('listening', function() {
  var address = server.address();
  console.log("gateway listening on " + address.address + ":" + address.port);
});

server.bind(2013);