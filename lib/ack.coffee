# # Ack

dgram = require 'dgram'

# - `incomingMessageFromDevice`   : buffer. raw message from the device
#     example:
#       <Buffer 01 05 B8 21 67 80 07 00 0E 00 00 00 00 00 00 00 01 01 64 CF 00 AA 28 68 80 07 00 80 1C 00>
      # to create test fixture:
      # new Buffer(["0x01", "0x05", "0xb8", "0x21", "0x67", "0x80", "0x07", "0x00", "0x0e", "0x00", "0x00", "0x00", "0x00", "0x00", "0x00", "0x00", "0x01", "0x01", "0x64", "0xcf", "0x00", "0xaa", "0x28", "0x68", "0x80", "0x07", "0x00", "0x80", "0x1c", "0x00"])
# - `rinfo` : object. contains `port` and `address` the message originated from
module.exports = (incomingMessageFromDevice, rinfo) ->

  # `outgoingAckMsg`  : response to a successful decode
  outgoingAckMsg = Buffer.concat [
    # `ACK` : string.
    # => <Buffer 41 43 4b>
    new Buffer('ACK')
    # 
    # `sequenceNumber`  : number.
    # possible values: 1 - 65535
    # rolls over to 1.
    incomingMessageFromDevice.slice(8, 10)

    # `status`: number. 0: ERROR, 1: OK
    new Buffer(["0x01"])
  ]

  sock = dgram.createSocket 'udp4'
  
  # send using outbound port 2013
  sock.bind 2013
  
  sock.send outgoingAckMsg, 0, outgoingAckMsg.length, rinfo.port, rinfo.address, (err, bytes) ->
    sock.close()