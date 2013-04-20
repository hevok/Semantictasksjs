###
  #MOCKSOCKET TEST
  It tests how websocket wrapper and channels work
###

chai = require 'chai'
chai.should()
expect = chai.expect;
require '../lib/batman.js'
require './mock_channels.coffee'
require '../collab/socket_event.coffee'
require '../collab/routers/simple_router.coffee'
require '../collab/channels/channel.coffee'
require '../collab/sockets/mock_socket.coffee'
require '../collab/sockets/cache_socket.coffee'
require '../collab/socket.coffee'


describe 'Mocksocket', ->
  it "should respond to save request",->

    channels = new Batman.MockChannels()
    mock = channels.getMock()

    mock.onreceive = (event)=>
      data = Batman.SocketEvent.fromData(event)
      if(data.request=="save")
        mock.onmessage(data)

    event =
      data:
        content: "BBC reports from mock"
        channel: "bbc"
        request: "save"

    mock.send event

    channels.bbc.last.should.equal "BBC reports from mock"

    event =
      content: "some default event"
      request: "save"

    mock.send event
    channels.def.last.should.equal "some default event"
    channels.bbc.last.should.equal "BBC reports from mock"
