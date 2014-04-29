# # Ack

dgram = require 'dgram'

# - `incomingMessageFromDevice`   : buffer. raw message from the device
# - `rinfo` : object. contains `port` and `address` the message originated from
module.exports = (incomingMessageFromDevice, rinfo) ->

  # `outgoingAckMsg`  : response to a successful decode
  outgoingAckMsg = Buffer.concat [
    # `msgType` : number.
    # hex value: 0xFF
    # => 255
    new Buffer([0xFF])
    # `sequenceNumber`  : number.
    # possible values: 1 - 65535
    # rolls over to 1.
    incomingMessageFromDevice.slice(8, 10)
  ]

  sock = dgram.createSocket 'udp4'
  
  # send using outbound port 2013
  sock.bind 2013
  
  sock.send outgoingAckMsg, 0, outgoingAckMsg.length, rinfo.port, rinfo.address, (err, bytes) ->
    sock.close()