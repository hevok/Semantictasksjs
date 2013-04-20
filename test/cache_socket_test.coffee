chai = require 'chai'
chai.should()
expect = chai.expect;
require '../lib/batman.js'
require '../collab/socket_event.coffee'
require '../collab/routers/simple_router.coffee'
require '../collab/sockets/cache_socket.coffee'



describe 'Cachesocket', ->
  it "should cache the data being sent inside itsefl and give to successor",->


  socket = new Batman.Socket("none")
  robot =
    data:
      content:

        id: "iRobot"
        text: 'I am still alive!'
        user: "Robot"
      request: "save"
      channel: "messages"


  mycode =
    data:
      content:
        id: "iMyCode"
        text:"Hi, guys! Look at my code!"
        user:"Anton"
      request: "save"
      channel: "messages"

  focus =
    data:
      content:
        id: "iFocus"
        text: "Comrades, it is not our primary focus, let's go and continue writing grant application!"
        user: "coced"
      request: "save"


  socket.send(robot)
  socket.send(focus)
  socket.send(mycode)
  mock = new Batman.MockSocket("url")
  socket.setWebsocket(mock)
  foc = mock.get "iFocus"
  foc.content.id.should.equal "iFocus"
  foc = mock.get "iRobot"
  foc.content.id.should.equal "iRobot"
  foc = mock.get "iMyCode"
  foc.content.id.should.equal "iMyCode"



