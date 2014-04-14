Firebase = require('firebase')
mandrill = require('mandrill-api/mandrill')
mandrill_client = new mandrill.Mandrill("7FesvdnRxOBqSRtg-zBtGA")


email_queue = new Firebase 'https://homeclub.firebaseio.com/email_queue'

email_queue.on 'child_added', (newEmail) ->

  email         = newEmail.child('email').val()  
  variables     = newEmail.child('variables').val() ? {}
  template_name = newEmail.child('template_name').val()
  
  template_content = Object.keys(variables).map (k) ->
    {name:k,content:variables[k]}

  message =
    to: [
      email: email
    ]

  mandrill_client.messages.sendTemplate
    "template_name": template_name
    "template_content": template_content
    message: message
  , (result) ->
    
    if result[0].status is 'sent'
      email_queue.child(newEmail.name()).remove (error) ->
        unless error
          console.log 'email_queue item removed'