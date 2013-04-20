chai = require 'chai'
chai.should()
expect = chai.expect;
require '../lib/batman.js'
require '../collab/socket_event.coffee'
require '../collab/routers/simple_router.coffee'
require '../collab/routers/chat_router.coffee'
require '../collab/channels//channel.coffee'
require '../collab/sockets/mock_socket.coffee'
require '../collab/socket.coffee'
require './mock_channels.coffee'
require './chat_channels.coffee'


describe 'Collab router', ->
  channels = new Batman.ChatChannels()
  mock = channels.getMock()
  socket = channels.socket
  router = new Batman.ChatRouter()
  socket.router = router


  it 'should transform and distribute info', ->
    event =
      data:
        kind: "join"
        user: "Robot"
        message:"has entered the room"
        members:["Robot","Daniel","Coced"]

    channels.allUsers.length.should.equal 0
    channels.allMessages.length.should.equal 0
    channels.allTasks.length.should.equal 0

    mock.onmessage event
    channels.allUsers.length.should.equal 1
    channels.allTasks.length.should.equal 0
    channels.allMessages.length.should.equal 1

    event =
      data:
        kind: "join"
        user: "Robot"
        message:"has left the room"
        members:["Robot","Daniel","Coced"]

    it "should save text messages", ->
      message =
        content:
          id:Batman.SocketEvent.genId()
          message:"some message"
      mock.onreceive =  (e)->JSON.parse(e).text.should.equal "some message"
      channels.messages.send  message

    mock.onreceive = Batman.MockSocket.mockCallback(mock)













