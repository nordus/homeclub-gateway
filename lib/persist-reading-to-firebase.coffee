# # Persist reading to firebase

request = require 'request'


module.exports = (reading) ->
  request.post "https://homeclub-gateway.firebaseIO.com/readings/#{reading.mobileId}.json?auth=#{process.env.FIREBASE_SECRET}",
    form: reading