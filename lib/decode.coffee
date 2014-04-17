# # Decode

ack = require './ack'
log = require './log'

# parse functions for each message type
parse =
  '2':  require('./msg-type-2')
  '4':  require('./msg-type-4')

# - `msg`   : buffer. raw message from the device
# - `rinfo` : object. contains `port` and `address` the message originated from
module.exports = (msg, rinfo) ->

  try
    # parse attributes common to all message types
    reading =
      mobileId:   msg.slice(2, 7).toString('hex')
      msgType:    msg.readUInt8 10
      seqNumber:  msg.readUInt16BE 11
      updateTime: (msg.readUInt32BE(13) * 1000)
      timeOfFix:  (msg.readUInt32BE(17) * 1000)
      # convert latitude, longitude to decimal
      latitude:   (msg.readInt32BE(21) / 10000000)
      longitude:  (msg.readInt32BE(25) / 10000000)
      # cm to ft
      altitude:   (msg.readInt32BE(29) * 0.0328084)
      # cm/second to mph
      speed:      (msg.readUInt32BE(33) * 0.022369362920544023)
      heading:    msg.readUInt16BE(37)
      satellites: msg.readUInt8(39)
      fixStatus:  msg.readUInt8(40)
      carrier:    msg.readUInt16BE(41)
      rssi:       msg.readInt16BE(43)
      commState:  msg.readUInt8(45).toString(2)
      # to units of 0.1
      hdop:       (msg.readUInt8(46) / 10)
      inputStates:  msg.readUInt8(47).toString(2)
      unitStatus: msg.readUInt8(48).toString(2)

    # append attributes specific to message type
    if typeof parse["#{reading.msgType}"] is 'function'
      parse["#{reading.msgType}"](msg, reading)
  
    # do not ack or save if in development
    if process.env.NODE_ENV is 'test'
      return reading
    else
      log.info reading, "SUCCESS parsing #{rinfo.size} bytes from #{rinfo.address}"
      
      ack(msg, rinfo)


  catch e
    log.error
      err:
        message : e.message
        name    : e.name
        stack   : e.stack
      hex: msg.toString('hex')
      text: msg.toString()
    , "ERROR parsing #{rinfo.size} bytes from #{rinfo.address}"