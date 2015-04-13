# # Message Type 1

module.exports = (msg, reading) ->

  # `networkHubSystemMessage`     : integer. see lookup table below.
  # - `0`                         : no message
  # - `1`                         : SUCCESS: Received SMS
  # - `2`                         : SUCCESS: Reset Network Hub
  # - `3`                         : SUCCESS: Add MAC address to white list
  # - `4`                         : SUCCESS: Remove MAC address from white list
  # - `5`                         : SUCCESS: Change NH reporting frequency
  # - `6`                         : TBD
  # - `7`                         : TBD
  # - `8`                         : TBD
  # - `9`                         : TBD
  # - `10`                        : ERROR: Sensor Hub update timeout
  # - `11`                        : TBD

  reading.networkHubSystemMessage = msg.readUInt8(16)

  # `sensorHubSystemMessage`      : integer. see lookup table below.
  # - `0`                         : No message
  # - `1`                         : SUCCESS: Updated SH settings based on HC2
  # - `2`                         : TBD
  # - `3`                         : TBD
  # - `4`                         : TBD
  # - `5`                         : TBD
  # - `6`                         : TBD
  # - `7`                         : TBD
  # - `8`                         : TBD
  # - `9`                         : TBD
  # - `10`                        : ERROR: Not able to update SH settings based on HC2
  # - `11`                        : TBD

  reading.sensorHubSystemMessage  = msg.readUInt8(17)


  # `bytesPerPayload`             : integer.
  # NOTE: bytesPerPayload is also documented as "Payload size in Bytes"

  reading.bytesPerPayload     = msg.readUInt8(18)


  charactersPerPayload = reading.bytesPerPayload * 2


  regEx = new RegExp("\\w{#{charactersPerPayload}}", 'g')


  # `payloads`: array
  payloads = msg.slice(19).toString('hex').match(regEx)

  if payloads
    payloads.forEach (payload, n) ->
      reading["payload#{n+1}"] = payload