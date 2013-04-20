###
#model for messages#
contains text and user fields
###
class Chat.Message extends Batman.Model
  ###
  model for messages
  contains text and user fields
  ###

  @encode 'id','text', 'user'
  ###
    id and two other fields to be stored: text and user
    when you make models do not forget about id
  ###


  @validate 'text', presence: true
  ###
    validate if text is present each time we create Message
  ###



  @persist Batman.SocketStorage
  ###
    messages are stored in socket storage
  ###


  @storageKey: 'messages'
  ###
    key for local (by the browser) storage
  ###


