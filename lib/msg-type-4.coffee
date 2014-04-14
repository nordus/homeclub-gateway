# # Message Type 4

module.exports = (msg, reading) ->
  reading.userMsgRoute  = msg.readUInt8(49)
  reading.userMsgId     = msg.readUInt8(50)
  reading.userMsgLength = msg.readUInt16BE(51)
  reading.userMsg       = msg.slice(53).toString('hex').toUpperCase().match(/\w{2}/g).join ' '
  reading.sensorHubId   = msg.slice(53, 61).toString().toUpperCase()
  reading.temperature   = msg.readInt8(61)
  reading.batteryPct    = msg.readUInt8(62)
  reading.bleRssi       = msg.readInt16BE(63)

  if reading.userMsgLength is 13
    reading.alertText   = msg.slice(65).toString()