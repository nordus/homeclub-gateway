# # Message Type 3

module.exports = (msg, reading) ->
  reading.payloadType       = msg.readUInt8(16)
  reading.bytesPerPayload   = msg.readUInt8(17)
  reading.nbrOfPayloads     = msg.readUInt8(18)

  charactersPerPayload = reading.bytesPerPayload * 2

  # using constructor so regular expression will be recompiled on each iteration
  regEx = new RegExp("\\w{#{charactersPerPayload}}", 'g')

  # `payloads`: array. members vary in length and content
  # TODO: find out why
  payloads = msg.slice(19).toString('hex').match(regEx)

  if payloads
    payloads.forEach (payload, n) ->
      reading["payload#{n+1}"] = payload