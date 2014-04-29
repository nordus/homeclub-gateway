# # Message Type 4

module.exports = (msg, reading) ->
  reading.sensorHubBattery    = msg.readUInt8(16)
  reading.sensorHubRssi       = msg.readInt8(17)
  #reading.sensorHubRssiUnused = msg.readInt8(17)
  reading.sensorHubMacAddress = msg.slice(19, 25).toString('hex').toUpperCase()
  reading.sensorEventStart    = msg.readUInt8(25)
  reading.sensorEventEnd      = msg.readUInt8(26)