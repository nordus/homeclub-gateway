# # Decode

parseArgOpts =
  default:
    graylog_server_ip: (process.env.GRAYLOG_SERVER_IP ? '127.0.0.1')

options     = require('minimist')(process.argv.slice(2), parseArgOpts)

ack         = require './ack'
log         = require('./log')(options.graylog_server_ip)
request     = require 'request'
postWebhook = require './post-webhook'
adminApp    = require './firebase-admin-app'
queueRef    = adminApp.database().ref 'queue/tasks'

carriers    = {}

request 'https://api.homeclub.us/carriers-by-network-hub',
  json                : true
  rejectUnauthorized  : false
, ( err, resp, body ) ->
  unless err
    carriers  = body

# parse functions for each message type
parse =
  '0': require('./msg-type-0')
  '1': require('./msg-type-1')
  '2': require('./msg-type-2')
  '3': require('./msg-type-3')
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
      # reversing order per Rod's request
      # "B82167800700" => "0007806721B8"
      macAddress          : msg.slice(2, 8).toString('hex').match(/\w{2}/g).reverse().join('').toUpperCase()
      sequenceNumber      : msg.readUInt16LE(8)
      # we receive 10 digit epoch timestamp, JavaScript requires 13
      updateTime          : ( msg.readUInt32LE(10) * 1000 )
      # signed
      rssi                : msg.readInt8(14)
      # rssiUnused        : msg.readInt8(15)

      # DEBUG
      # TODO: remove once we solidify message format
      hex                 : msg.toString('hex')


    # append attributes specific to message type
    if typeof parse["#{reading.msgType}"] is 'function'
      parse["#{reading.msgType}"](msg, reading)


    # append carrier
    if carrier = carriers[reading.macAddress]
      reading.carrier = carrier


    # do not ack or save if in development
    if process.env.NODE_ENV is 'test'
      return reading
    else
      log.info reading, "SUCCESS parsing #{rinfo.size} bytes from #{rinfo.address}"

      queueRef.push reading

      ack(msg, rinfo)

      gatewayEvent = reading.msgType is 2 and reading.gatewayEventCode in [1,2]
      sensorHubEvent = reading.msgType is 4
      url = 'https://api.homeclub.us/webhooks'

      # `msgType1`  : ACK or outcome. SMS initiated.
      if reading.msgType is 1

        # - `networkHubSystemMessage` : integer.  ACK from SMS.
        smsInitiatedAck     = reading.networkHubSystemMessage

        # - `sensorHubSystemMessage`  : integer.  outcome of HC2.
        smsInitiatedOutcome = reading.sensorHubSystemMessage

        if smsInitiatedAck
          url += '/sms-initiated-ack'

        if smsInitiatedOutcome
          url += '/sms-initiated-outcome'

        postWebhook url, reading


      if sensorHubEvent
        url += '/sensor-hub-event'
        postWebhook url, reading

      if gatewayEvent
        url += '/network-hub-event'
        postWebhook url, reading


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
