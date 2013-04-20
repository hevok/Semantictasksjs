#a view for tasks of this chat
class Chat.UserView extends Batman.View
  constructor: ->
    # process arguments and stuff
    super
    #write node to separate variable, node is an HTMLNode to which view is attached to
    #$node = $ @get("node")


#a view for messages of this chat
class Chat.MessageView extends Batman.View
  ###
    View for messages of this chat
  ###
  constructor: ->
    # process arguments and stuff
    super
    #writes node to separate variable, node is an HTMLNode to which view is attached to
    #@node = $ @get("node")

#a view for tasks of this chat
class Chat.TaskView extends Batman.View
  constructor: ->
    # process arguments and stuff
    super
    #write node to separate variable, node is an HTMLNode to which view is attached to
   # @node = $ @get("node")
   # @node.fadeTo("slow",0.5)
   # @node.mouseover(->node.fadeTo("fast",0.8))
   # @node.mouseout -> node.fadeTo("fast",0.5)
   # @node.mousedown(->node.fadeTo("fast",1))




