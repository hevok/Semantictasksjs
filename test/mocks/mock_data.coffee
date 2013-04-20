###
   #MockData#
  this class creates some mock data to work with
###
class Chat.MockData extends Batman.Object
  ###
  this class creates some mock data to work with
  ###

  constructor: ->
    @socket = Batman.Socket.getInstance()
    @massenger = @socket.socket


  showDaniel : 'Show this code to Daniel'
  integrate : 'Integrate with semantic chat application'
  runCode : 'Run this code in the browser'

  createTasks: (num = 1)=>
    ###
    creates mock tasks
    ###
    #JSON test
    json =
      owner: 'Robot'
      title: 'Tell them that I am alive'
      completed: false

    switch num
      when 1 then new Chat.Task(owner: "Anton", title: @showDaniel, completed: false).save()
      when 2 then new Chat.Task(owner: "Anton",title: @integrate, completed: false).save()
      when 3 then new Chat.Task(owner: "Daniel",title: @runCode, completed: false).save()
      #I used here JSON just to show another method to save data
      when 4 then Chat.Task.createFromJSON(json).save()
      else
        @createTasks(1)
        @createTasks(2)
        @createTasks(3)
        @createTasks(4)



  createMessages: (num = 1)=>
    ###
    creates mock messages
    ###
    json =
      text: 'I am still alive!'
      user: "Robot"
    switch num
      when 1
        @massenger.onmessage
          data:
            content:
              text:"Hi, guys! Look at my code!"
              user:"Anton"
            request: "push"
            channel: Chat.Message.storageKey
      when 2
        new Chat.Message(text: "Wait a moment, I shall see", user: "Daniel").save()
        @completeTasksByTitle(@runCode)
        @completeTasksByTitle(@showDaniel)
      when 3 then new Chat.Message(text: "Comrades, it is not our primary focus, let's go and continue writing grant application!", user: "coced").save()
      when 4
        #I used here JSON just to show another method to save data
        Chat.Message.createFromJSON(json).save()
        @completeTasksByOwner("Robot")
      else
        @createMessages(1)
        @createMessages(2)
        @createMessages(3)
        @createMessages(4)


  #creates mock users
  createUsers: =>
    #checks if there are no users
    #if(not Chat.User.get('all').length)
    #creates mock users

    new Chat.User(name: "Anton", status:"active").save()
    new Chat.User(name: "Daniel", status:"active").save()
    new Chat.User(name: "coced", status:"active").save()
    new Chat.User(name: "Robot", status:"active").save()


  randomInt: (min, max)=>
    ###
      random int generating function
    ###
    Math.floor(Math.random() * (max - min + 1)) + min

  generate: =>
    ###
      callback that generates mock data (one of two test objects each second)
    ###
    num = @randomInt(1,4)
    switch @randomInt(1,3)
      when 1 then @createTasks(num)
      when 2 then @createMessages(num)
      when 3 then @createMessages(num)
    setTimeout(@generate, 2500)

  completeTasksByOwner: (owner)=>
    ###
    Completes all tasks that has this owner
    ###
    all = Chat.Task.get("all").toArray()
    for item in all
      if item.get("owner") == owner and item.get("completed")==false
        #in Batman.js it is recommended to use set("propname",value) instead of object.prop = value
        #because set not only saves the value but also do a lot of other useful stuf (like views and binding updates)
        item.set "completed", true

  completeTasksByTitle: (title)=>
    ###
    Completes all tasks that has this title
    ###
    all = Chat.Task.get("all").toArray()
    for item in all
      #console.log  item.get "title"
      if item.get("title") == title and item.get("completed")==false
        #in Batman.js it is recommended to use set("propname",value) instead of object.prop = value
        #because set not only saves the value but also do a lot of other useful stuf (like views and binding updates)
        item.set "completed", true

  kill : (items)=>
    ###
    Deletes items from localStorage of HTML
    ###
    arr = items.toArray()
    for item in arr
      item.destroy()

  cleanUp: =>
    ###
    cleanup localstore
    ###
    @kill Chat.Message.get("all")
    @kill Chat.User.get("all")
    @kill Chat.Task.get("all")











