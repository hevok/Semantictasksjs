class Chat.Login extends Batman.Object
  ###
    Works with logging in logic
  ###

  @set "signed", false
  @set "currentUser", new Chat.User(id:Batman.SocketEvent.genId(),name:"",password:"")
  #writes node to separate variable, node is an HTMLNode to which view is attached to
  #@node = $ @get("node")

  @login: (userName, password)->
    user = @get "currentUser"
    user.set "name", userName
    user.set "password", password
    @set "signed", true
    user.save()

  @loginClick: (node,event)->
    ###
      this function connects to socket when logging in
    ###
    currentUser = @get "currentUser"
    user = currentUser.get("name")
    password = currentUser.get("password")
    unless Chat.Login.validate(user,password, true) then return false
    url = Batman.container.websocketURL.replace(/&amp;/g,"&").replace("nouser",user).replace("none",user).replace("nopassword",password)
    Batman.container.websocketURL = url
    message =
      user: user
      password: password
      websocketURL: url
    Chat.send message


  @validate: (user,password, alerts = false)->
    ###
      checks if user and password are valid
    ###
    unless (Batman.container.worker? or Batman.container.websocketURL?)
      if alerts then alert "NO WEBWORKERS DETECTED!"
      return false

    if password.length<3
      if alerts then alert  "too short password"
      return false

    if user.length<3
      if alerts then alert "too short username"
      return false
    return true
###
  ##Message board view model. Needed for various sophisticated operations with messages
###
class Chat.MessageBoard extends Batman.Object

  @set "text",""


  @classAccessor "items",-> Chat.Message.get("loaded") #.toArray().reverse()



  @newMessage: =>
    ###
      creates new empty message for binding
    ###
    new Chat.Message(user:Chat.Login.get("currentUser.name"),text:Chat.MessageBoard.get("text")) #bad code

  @pressKey: (node,event)=>
    if event.keyCode == 13  and not (event.altKey or event.ctrlKey or event.shiftKey)
      Chat.MessageBoard.addNew(node,event)


  @addNew: (node,event)=>
    ###
      Adds new message
    ###
    if Chat.MessageBoard.get("text").length>1
      message = Chat.MessageBoard.newMessage()
      message.save()
      @set "text", ""


class Chat.TaskBoard extends Batman.Object

  @set "hideCompleted", false

  @classAccessor "items",->
    Chat.Task.get("all")
      .filter (task)-> not Chat.TaskBoard.get("hideCompleted") || not task.get('completed')

  @set "title",""

  @pressKey: (node,event)=>
    if event.keyCode == 13  and not (event.altKey or event.ctrlKey or event.shiftKey)
      Chat.TaskBoard.addNew(node,event)

  @newTask: =>
    ###
      creates new empty message for binding
    ###
    new Chat.Task(id:Batman.SocketEvent.genId(), owner:Chat.Login.get("currentUser.name"),title:Chat.TaskBoard.get("title"),completed:false) #bad code

  @addNew: (node,event)=>
    ###
      Adds new message
    ###
    if Chat.TaskBoard.get("title").length>1
      task = Chat.TaskBoard.newTask()
      task.save()
      @set "title", ""


jQuery ->
  gridster = $(".gridster ul").gridster().data('gridster');
  users = $ "#userboard"
  messages = $ "#messageboard"
  tasks = $ "#taskboard"
  frame = $ "#frameboard"
  graph = $ "#graphboard"
  search = $ "#searchboard"

  myvid = $ "#myvideo"
  othervid1 = $ "#othervideo1"
  othervid2 = $ "#othervideo2"

  gridster.add_widget(othervid1, 1, 1, 1, 1)
  gridster.add_widget(othervid2, 1, 1, 2, 1)
  gridster.add_widget(myvid, 1, 1, 3, 1)

  gridster.add_widget(search, 1, 1, 1, 3)
  gridster.add_widget(graph, 2, 2, 1, 2)


  gridster.add_widget(messages, 1, 2, 3, 2)
  gridster.add_widget(tasks, 1, 2, 3, 4)

  #gridster.add_widget(users, 1, 2, 4, 1);
  #gridster.add_widget(frame, 3, 3, 1, 5);


class Chat.VideoBoard extends Batman.Object

  video: null
  videoOther1: null
  videoOther2: null
  instance: null

  constructor: ->
    ###
      receives elements
    ###
    @video = document.getElementById('mywebcam');
    @video.autoplay = true

    @videoOther1 = document.getElementById('webcam1');
    @videoOther1.autoplay = true

  loginHandler: (data)->
    ###
      creates two test videos
    ###
    socket = Batman.Socket.getInstance()
    first2second = socket.getVideoChannel("myvideo","othervideo1")
    first2second.subscribeLocal(@video)
    first2second.subscribeRemote(@videoOther1)
    first2second.call()

Chat.on "login", (data)=>
  unless Chat.VideoBoard.instance? then Chat.VideoBoard.instance =new Chat.VideoBoard()
  Chat.VideoBoard.instance.loginHandler(data)
class Chat.SearchBoard extends Batman.Object
class Chat.SearchResultBoard extends Batman.Object
class Chat.FrameBoard extends Batman.Object
onLogin = (data)=>
  graph = Viva.Graph.graph()
  graph.addLink(1, 2)
  graph.addLink(2, 3)

  cont = $("#graph").get(0)

  params =
    container: cont

  renderer = Viva.Graph.View.renderer(graph, params)
  renderer.run()

Chat.on "login", onLogin

