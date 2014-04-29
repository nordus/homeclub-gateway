# # Message Type 5

module.exports = (msg, reading) ->
  reading.sensorHubType       = msg.readUInt8(16)
  reading.numberOfSensors     = msg.readUInt8(17)
  reading.sensorHubBattery    = msg.readUInt8(18)
  reading.sensorHubRssi       = msg.readInt8(19)
  #reading.sensorHubRssiUnused = msg.readInt8(20)
  reading.sensorHubMacAddress = msg.slice(21, 27).toString('hex').toUpperCase()
  
  # offset of signed values within sensorHubData
  # this is the only value we use and toss out
  # NOTE: we are currently returning reading.offsetOfSigned for debugging
  # TODO: change reading.offsetOfSigned => offsetOfSigned
  reading.offsetOfSigned      = msg.slice(27, 28)[0].toString(2)

  # `sensorHubData` : array.
  # [0..1] : temperature. signed 16-bit integer
  # [2..3] : light.       unsigned 16-bit integer
  # [4..5] : humidity.    unsigned 16-bit integer
  sensorHubData = msg.slice(28)

  # with three dots the range excludes the last number
  for idx in [0...reading.numberOfSensors]  
    reading["sensorHubData#{idx+1}"] = sensorHubData.readUInt16BE(idx*2)