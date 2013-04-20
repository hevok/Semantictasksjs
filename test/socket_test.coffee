###
  #SOCKET TEST
  It tests how websocket wrapper and channels work
###

chai = require 'chai'
chai.should()
expect = chai.expect;
require './mock_channels.coffee'
require '../lib/batman.js'
require '../collab/socket_event.coffee'
require '../collab/routers/simple_router.coffee'
require '../collab/channels/channel.coffee'
require '../collab/sockets/mock_socket.coffee'
require '../collab/socket.coffee'


describe 'Socket', ->


  it 'runs test', ->
    ###
    Just a sample test to test if all is working well
    ###
    truth = "aging kills"
    truth.should.equal("aging kills")

  it 'should broadcast info to the channels', ->

    channels = new Batman.MockChannels()
    mock = channels.getMock()
    socket = channels.socket

    event =
      data: "Hello default"
    event.data.channel = "default"

    data = Batman.SocketEvent.fromEvent(event)
    data.content.should.equal "Hello default"

    socket.broadcast(Batman.SocketEvent.fromEvent(event))
    channels.def.last.should.equal "Hello default"
    channels.all.last.should.equal ""
    channels.cnn.last.should.equal ""

    socket.broadcast(new Batman.SocketEvent("Hello CNN", "cnn"))

    channels.def.last.should.equal "Hello default"
    channels.all.last.should.equal ""
    channels.cnn.last.should.equal "Hello CNN"
    channels.bbc.last.should.equal ""

  it "should work well with JSON", ->

    channels = new Batman.MockChannels()
    mock = channels.getMock()


    report =
      message:"BBC reports"
      user: "mock"


    event =
      data:
        content: JSON.stringify(report)
        channel: "bbc"
        request: "save"

    event.data = JSON.stringify(event.data)

    channels.bbc.last.should.equal = ""
