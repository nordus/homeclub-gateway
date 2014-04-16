# # Message Type 2

module.exports = (msg, reading) ->
  reading.eventIndex        = msg.readUInt8(49)
  reading.eventCode         = msg.readUInt8(50)
  reading.nbrOfAccumulators = msg.readUInt8(51)