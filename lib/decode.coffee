# # Decode

ack = require './ack'
log = require './log'

# parse functions for each message type
parse =
  '0': require('./msg-type-0')
  '2': require('./msg-type-2')
  '4': require('./msg-type-4')
  '5': require('./msg-type-5')

# - `msg`   : buffer. raw message from the device
# - `rinfo` : object. contains `port` and `address` the message originated from
module.exports = (msg, rinfo) ->

  try
    # parse attributes common to all message types
    reading =
      serviceType         : msg.readUInt8(0)
      msgType             : msg.readUInt8(1)
      macAddress          : msg.slice(2, 8).toString('hex').toUpperCase()
      sequenceNumber      : msg.readUInt16BE(8)
      # we receive 10 digit epoch timestamp, JavaScript requires 13
      updateTime          : ( msg.readUInt32BE(10) * 1000 )
      # signed
      rssi                : msg.readInt8(14)
      # rssiUnused        : msg.readInt8(15)


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
    logObject =
      err:
        message : e.message
        name    : e.name
        stack   : e.stack
      hex: msg.toString('hex')
      text: msg.toString()
    
    if process.env.NODE_ENV is 'test'
      return logObject
    else
      log.error logObject, "ERROR parsing #{rinfo.size} bytes from #{rinfo.address}"