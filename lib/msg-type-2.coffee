# # Message Type 2

module.exports = (msg, reading) ->
  reading.gatewayBattery    = msg.readUInt8(16)
  reading.gatewayEventCode  = msg.readUInt8(17)