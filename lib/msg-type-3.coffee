# # Message Type 3

module.exports = (msg, reading) ->
  reading.payloadType       = msg.readUInt8(16)
  reading.bytesPerPayload   = msg.readUInt8(17)
  reading.nbrOfPayloads     = msg.readUInt8(18)

  payloads = msg.slice(19).toString('hex').match(/\w{12}/g)

  if payloads
    payloads.forEach (payload, n) ->
      reading["payload#{n+1}"] = payload