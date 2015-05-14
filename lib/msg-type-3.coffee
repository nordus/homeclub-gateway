# # Message Type 3

module.exports = (msg, reading) ->
  reading.payloadType       = msg.readUInt8(16)
  reading.bytesPerPayload   = msg.readUInt8(17)
  reading.nbrOfPayloads     = msg.readUInt8(18)

  charactersPerPayload = reading.bytesPerPayload * 2

  # using constructor so regular expression will be recompiled on each iteration
  regEx = new RegExp("\\w{#{charactersPerPayload}}", 'g')

  # `macAddresses`: array
  macAddresses = msg.slice(19).toString('hex').match(regEx)

  if macAddresses
    macAddresses.forEach (macAddress, n) ->
      # incoming MAC addresses are reverse byte
      macAddressFormatted = macAddress.match(/\w{2}/g).reverse().join('').toUpperCase()
      reading["macAddress#{n+1}"] = macAddressFormatted