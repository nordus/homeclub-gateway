# # Logger

bunyan      = require('bunyan')
gelfStream  = require('gelf-stream')
#stream      = gelfStream.forBunyan('127.0.0.1')

#log = bunyan.createLogger
#  name: 'gateway'
#  streams: [
#    type: 'raw'
#    stream: stream
#  ]


module.exports = ( graylogServerIP ) ->

  stream  = gelfStream.forBunyan( graylogServerIP, 12202 )

  bunyan.createLogger
    name: 'gateway'
    streams: [
      type: 'raw'
      stream: stream
    ]