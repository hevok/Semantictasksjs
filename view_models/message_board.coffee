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

