###
  #Mock class for testing with socket channels#
###
require '../lib/batman.js'
require '../collab/sockets/cache_socket.coffee'
require '../collab/sockets/mock_socket.coffee'
require '../collab/socket.coffee'

class Batman.TestChannels
  constructor: (@url="none")->
    Batman.container.websocket = null
    Batman.container.socket = null
    @socket = new Batman.Socket(@url)
    @socket.setWebsocket(new Batman.MockSocket(@url))
    @def = @socket.getChannel("default")
    @all = @socket.getChannel("all")


  subscribeChannels: ->
    ###
      fill variables with last values
    ###
    @def.onmessage = (evt)=>@def.last = evt.content
    @all.onmessage = (evt)=>@all.last = evt.content

  getMock:=>
    ###
      returns mock socket
    ###
    @socket.websocket

  cleanLasts: ->
    @def.last = @all.last = ""

class Batman.MockChannels extends Batman.TestChannels
  ###
    ##Mock class for testing with socket channels##
  ###

  constructor: (url="none")->
    super(url)
    @bbc = @socket.getChannel("bbc")
    @cnn = @socket.getChannel("cnn")
    @ictv = @socket.getChannel("ictv")
    @cleanLasts()
    @subscribeChannels()


  subscribeChannels: ->
    ###
      fill variables with last values
    ###
    super()
    @bbc.onmessage = (evt)=>@bbc.last = evt.content
    @cnn.onmessage = (evt)=>@cnn.last = evt.content
    @ictv.onmessage = (evt)=>@ictv.last = evt.content



  cleanLasts: ->
    super()
    @bbc.last = @cnn.last = @ictv.last = ""


