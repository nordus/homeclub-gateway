request = require('request')


module.exports = (url, json) ->
  request url,
    method  : 'POST'
    json    : json
  , ( err, resp, body ) ->
    console.log err  if err
