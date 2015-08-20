postWebhook = require './post-webhook'


module.exports = ->
  for phoneNumber in ['+14807880022', '+16024608023']
    postWebhook 'http://homeclub.us/api/sms',
      to    : phoneNumber
      body  : '[Senteri internal]  Gateway started!'