chai = require 'chai'
chai.should()
expect = chai.expect;
require './mock_channels.coffee'
require '../lib/batman.js'
require '../collab/socket_event.coffee'
require '../collab/channels/channel.coffee'
require '../collab/routers/simple_router.coffee'
require '../collab/sockets/mock_socket.coffee'
require '../collab/socket.coffee'
require '../collab/socket_storage.coffee'


###
  There will be tests for SocketStorage
###
class Batman.MockModel extends Batman.Object
  ###
  Just a mock model class to test storage
  ###
  @storageKey: 'messages'

  @_doStorageOperation: (operation, options, callback) ->
    Batman.developer.assert @::hasStorage(), "Can't #{operation} model #{Batman.functionName(@constructor)} without any storage adapters!"
    adapter = @::_batman.get('storage')
    adapter.perform(operation, @, options, callback)

  _doStorageOperation: (operation, options, callback) ->
    Batman.developer.assert @hasStorage(), "Can't #{operation} model #{Batman.functionName(@constructor)} without any storage adapters!"
    adapter = @_batman.get('storage')
    adapter.perform operation, @, options, =>
      callback(arguments...)

  @persist: (mechanism, options...) ->
    Batman.initializeObject @prototype
    mechanism = if mechanism.isStorageAdapter then mechanism else new mechanism(@)
    Batman.mixin mechanism, options... if options.length > 0
    @::_batman.storage = mechanism
    mechanism




describe "With socket channels we", ->

  channels = new Batman.MockChannels()
  mock = channels.getMock()

  id1 = Batman.SocketEvent.genId()
  id2 = Batman.SocketEvent.genId()

  event1 =
    content:
      id:id1
      data: "somecontent1"

  event2 =
    content:
      id:id2
      data:"somecontent2"

  it "save information", ->

    channels.ictv.save event1
    channels.ictv.save event2


    mock.get(id1).content.data.should.equal("somecontent1")
    mock.get(id2).content.data.should.equal("somecontent2")

    arr = mock.get(channels.ictv.name).toArray()
    arr[0].data.should.equal("somecontent1")
    arr[1].data.should.equal("somecontent2")


  it "read information", ->
    channels.ictv.onNextMessage (event)=>
      event.content.data.should.equal "somecontent2"

    channels.ictv.read id2

    channels.ictv.onNextMessage (event)=>
      event.content.data.should.equal "somecontent1"

    channels.ictv.read id1


  it "read all information", ->

    channels.ictv.onNextMessage (event)=>
      event.request.should.equal "readAll"
      arr = event.content
      arr[0].data.should.equal "somecontent1"
      arr[1].data.should.equal "somecontent2"
    channels.ictv.readAll()

  it "update information", ->
    upd =
      content:
        id:id2
        data:"somecontent20"
    channels.ictv.save upd

    arr = mock.get(channels.ictv.name).toArray()
    arr.length.should.equal 2
    arr[0].data.should.equal("somecontent1")
    arr[1].data.should.equal("somecontent20")


  it "remove information", ->
    arr = mock.get(channels.ictv.name).toArray()
    arr.length.should.equal 2
    arr[0].data.should.equal("somecontent1")
    arr[1].data.should.equal("somecontent20")

    channels.ictv.remove id1
    arr = mock.get(channels.ictv.name).toArray()
    arr.length.should.equal 1
    arr[0].data.should.equal("somecontent20")

  it "another test", ->
    task =
      one:"oneVal"
      two:"twoVal"
      three:"threeVal"



