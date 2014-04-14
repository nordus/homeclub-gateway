# # Persist reading to firebase

Firebase = require('firebase')

module.exports = (reading) ->
  if reading.msgType is 2
    if reading.eventCode is 6
      readingType = 'heartbeats'
    else
      readingType = 'power_status_events'
  else
    readingType = 'readings'
  readingForMobileId = new Firebase "https://homeclub.firebaseio.com/#{readingType}/#{reading.mobileId}"
  readingForMobileId.push().setWithPriority reading, reading.updateTime