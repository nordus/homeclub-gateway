request = require('request')


module.exports = (url, json) ->
  request url,
    method  : 'POST'
    json    : json