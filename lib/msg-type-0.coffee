# # Message Type 0

module.exports = (msg, reading) ->
  reading.gatewayBattery      = msg.readUInt8(16)
  reading.sensorHubsConnected = msg.readUInt8(17)