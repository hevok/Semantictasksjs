###
#User class#
model for users of the chat, now is only used for test purposes
Class for chat users
###

class Chat.User extends Batman.Model
  ###
  Class for chat users
  ###

  #@set("currentUser", null)

  #declares that properties name and status will be saved when @save() is called
  @encode  'id', 'name', 'status', 'password'

  #validate if name is present each time we create User
  @validate 'name', presence: true


  @persist Batman.SocketStorage
  ###
    messages are stored in socket storage
  ###


  #key for local (by the browser) storage
  @storageKey: 'users'

  @login: ->
    alert "LOGIN MODEL!"
    console.log "LOGIN MODEL!"



