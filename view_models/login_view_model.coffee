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