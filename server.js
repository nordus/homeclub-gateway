require('es6-shim');

var trans = require('coffee-script');
if (trans.register) {
  trans.register();
}
var dgram   = require('dgram');
var decode  = require('./lib/decode');
var sendGatewayUpSms  = require('./lib/send-gateway-up-sms');

var server  = dgram.createSocket('udp4', decode);

server.on('listening', function() {
  var address = server.address();
  console.log("gateway listening on " + address.address + ":" + address.port);
  sendGatewayUpSms()
});

server.bind(2013);
