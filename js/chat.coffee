###
  #Chat App#
  Application coffee of the chat
###

#disable routingkey warnings for controllers
Batman.config.minificationErrors = false

class Chat extends Batman.App
  #@route

  ###
  Application object of the chat
  ###

  @root ''
  #@route "/completed", "tasks#completed"
  #@route "/active", "tasks#active"

  @workerHandler: (e)->
    ###
      handles worker messages
    ###
    Chat.login(e.data)

  @login: (data)->
    ###
      functions that fires when you logged in
      The loggin message can come from both shared webworker and loginform
      ant that is a reason why I put it here
    ###
    if data.user? and data.password?
      if Chat.Login.validate(data.user, data.password)
        ###
          check if everything is OK with username and password
        ###
        Chat.Login.login(data.user,data.password)
        socket = Batman.Socket.getInstance(data.websocketURL)

        socket.router = new Batman.SimpleRouter()

        if Chat.ws?
          #checks if we are connecting directly or there is a shared webworker that does it for us
          socket.setWebsocket Chat.ws
        else
          socket.setWebsocket new WebSocket(data.websocketURL)
        Chat.fire("login", data)

  @initWorker: ->
    ###
      Decides whether it should connect directly or through shared webworker
    ###
    if Batman.container.workerURL?
      Chat.ws = new Batman.WorkerSocket(Batman.container.workerURL)
      Chat.ws.onmessage = (e)->Chat.workerHandler(e)

  @send: (data)->
    ###
      TODO: rename the function
    ###
    if Chat.ws?
      Chat.ws.send(data)
    else
      Chat.login(data)

#stores to global container
container = Batman.container
container.Chat = Chat

class Batman.EmptyDispatcher extends Batman.Object
  ###
  to switch routing off
  ###


#add listener to the window object to fire run when everything has been loaded
if(window?)
  window.addEventListener 'load', ->
    disp = new Batman.EmptyDispatcher()
    Chat.set "navigator", disp
    Chat.set "dispatcher", disp
    Chat.run()
    Chat.initWorker()



