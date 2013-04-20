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



###
  #model for the task#
  contains owner, title and completed of the task
###

class Chat.Task extends Batman.Model
  ###
  model for the task
  contains owner, title and completed of the task
  ###


#declares that properties title and completed will be saved when @save() is called
  @encode 'id','owner','title', 'completed'


  @persist Batman.SocketStorage
  #@persist Batman.LocalStorage
  ###
    messages are stored in socket storage
  ###

  #validate if title is present each time we create Task
  @validate 'title', presence: true

  #key for local (by the browser) storage
  @storageKey: 'tasks'

  @classAccessor 'active', ->
    ###return all active tasks###
    @get('all').filter (task) -> !task.get('completed')

  #returns all completed tasks
  @classAccessor 'completed', ->
    ###
      gets all tasks and than applies filter function
    ###
    @get('all').filter (task) -> task.get('completed')

  @wrapAccessor 'title', (core) ->
    set: (key, value) -> core.set.call(@, key, value?.trim())


###
#model for search query#
contains id and query fields
###
class Chat.Search extends Batman.Model
  ###
  contains id and query fields
  ###

  @encode 'id','query'
  ###
    id and two other fields to be stored: text and user
    when you make models do not forget about id
  ###


  @persist Batman.SocketStorage
  ###
    searches are stored in socket storage
  ###

  @storageKey: 'searches'



###
#model for frames loading#
###
class Chat.Search extends Batman.Model
  ###
  contains id and query fields
  ###

  @encode 'id','url'
  ###
    id and url to be stored
  ###


  @persist Batman.SocketStorage
  ###
    searches are stored in socket storage
  ###

  @storageKey: 'frames'


class Chat.SearchResult extends Batman.Model

###
#model for messages#
contains text and user fields
###
class Chat.Graph extends Batman.Model
