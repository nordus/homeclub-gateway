# # Message Type 1

module.exports = (msg, reading) ->
  reading.systemMsgType     = msg.readUInt8(16)
  reading.msgError          = msg.readUInt8(17)
  reading.payloadSize       = msg.readUInt8(18)

  if reading.payloadSize isnt 0
    reading.payload         = msg.slice(19).toString('hex')