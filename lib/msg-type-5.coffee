# # Message Type 5

module.exports = (msg, reading) ->
  reading.sensorHubType       = msg.readUInt8(16)
  reading.numberOfSensors     = msg.readUInt8(17)
  reading.sensorHubBattery    = msg.readUInt8(18)
  reading.sensorHubRssi       = msg.readInt8(19)
  #reading.sensorHubRssiUnused = msg.readInt8(20)
  # reversing order per Rod's request
  # "B82167800700" => "0007806721B8"
  reading.sensorHubMacAddress = msg.slice(21, 27).toString('hex').match(/\w{2}/g).reverse().join('').toUpperCase()
  
  # offset of signed values within sensorHubData
  # this is the only value we use and toss out
  # NOTE: we are currently returning reading.offsetOfSigned for debugging
  # TODO: change reading.offsetOfSigned => offsetOfSigned
  reading.offsetOfSigned      = msg.slice(27, 28)[0].toString(2)

  # `sensorHubData` : array.
  # encoding is little endian
  # [0..1] : temperature. signed 16-bit integer
  temperatureIndex  = 0
  # [2..3] : light.       unsigned 16-bit integer
  # [4..5] : humidity.    unsigned 16-bit integer
  sensorHubData     = msg.slice(28)

  # with three dots the range excludes the last number
  #
  # TODO: only octets specified in offsetOfSigned
  # should be read as 16-bit signed
  #
  for idx in [0...reading.numberOfSensors]  
    reading["sensorHubData#{idx+1}"] = sensorHubData.readInt16LE(idx*2)
    #if idx is temperatureIndex
      #reversedBuffer = new Buffer((sensorHubData.slice((idx*2), ((idx*2)+2)).toString('hex').match(/\w{2}/g).reverse()))
      #reading["sensorHubData#{idx+1}"] = reversedBuffer.readInt16LE 0
    #else
      #reading["sensorHubData#{idx+1}"] = sensorHubData.readInt16LE(idx*2)