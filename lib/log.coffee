bunyan      = require('bunyan')
gelfStream  = require('gelf-stream')
stream      = gelfStream.forBunyan('gateway.homeclub.us')

log = bunyan.createLogger
  name: 'gateway'
  streams: [
    type: 'raw'
    stream: stream
  ]


module.exports = log