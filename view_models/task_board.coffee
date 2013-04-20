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

