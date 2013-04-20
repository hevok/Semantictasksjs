require '../lib/batman.js'
require '../collab/sockets/cache_socket.coffee'
require './mock_channels.coffee'
class Batman.ChatChannels extends Batman.TestChannels

  constructor: (url="none")->
    super(url)
    @messages = @socket.getChannel("messages")
    @tasks = @socket.getChannel("tasks")
    @users = @socket.getChannel("users")
    @cleanLasts()
    @subscribeChannels()

  allUsers : []
  allMessages : []
  allTasks : []


  subscribeChannels: ->
    super()
    @users.onmessage = (evt)=> @allUsers.push evt.content
    @messages.onmessage = (evt)=> @allMessages.push evt.content
    @tasks.onmessage = (evt)=> @allTasks.push evt.content
