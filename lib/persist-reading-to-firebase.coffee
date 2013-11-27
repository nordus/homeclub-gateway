# # Persist reading to firebase

Firebase = require('firebase')

module.exports = (reading) ->
  console.log '-= PERSISTING READING =-'
  console.log reading
  
  readingForMobileId = new Firebase "https://homeclub-gateway.firebaseio.com/readings/#{reading.mobileId}"
  readingForMobileId.push reading