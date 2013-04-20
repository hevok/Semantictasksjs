class AbstractSocketWorker
  constructor: ->
    @connections = 0
    @ports = []

  connections: 0

  connect: (e)->
    @lastPort = e.ports[0]
    @ports.push @lastPort
    @connections++

  postMessage: (data)=>
    @lastPort.postMessage(data)

  listenAll: (fun)=>
    unless @ports? or @ports.length==0 then return
    num = 0
    while num < @ports.length
      port = @ports[num]
      port.onmessage = (e)->fun(e)
      num++

  notifyAll: (data)=>
    unless @ports? or @ports.length==0 then return
    num = 0
    while num < @ports.length
      port = @ports[num]
      port.postMessage(data)
      num++


  broadcast: (data)=>
    num = 0
    while num < @ports.length
      port = @ports[num]
      port.postMessage(data)
      num++


class MockWorker extends AbstractSocketWorker
  ###
    It is mock version of Basicworker
  ###


  onopen: =>

  onmessage: (event)=>

  sendBack: (d)=>
    ###
      swaps room and channel ans sends data back
      it is needed for p2p testing
    ###
    newChannel = d.room
    d.room = d.channel
    d.channel = newChannel
    if @websocket? then  @websocket.onmessage(data:d)

  send: (e)=>
    data = JSON.parse(e)
    req = data.request
    if req == "sendback" or req=="answer" or req=="offer" or req=="ICE" then @sendBack(data)



  onclose: =>

  createWebsocket: (user, password, url)->
    if url!="none" then url = url.replace("none",user)
    @generate()
    return @


  randomInt: (min, max)=>
    ###
      random int generating function
    ###
    Math.floor(Math.random() * (max - min + 1)) + min


  generate: =>
    ###
      callback that generates mock data (one of two test objects each second)
    ###
    len = @arr.length-1
    r = @randomInt(0,len)
    message = @arr[r]
    if @websocket? then  @websocket.onmessage(message)
    setTimeout(@generate, 2500)
class BasicWorker extends MockWorker
  ###
    It is mockworker created to test the chat data
    it is called "BasicWorker" in order to be easily inserted in test builds instead of normal BasicWorker class
  ###
###
  This is a shared worker that containes websocket connection inside itself
  the connection is shared between several
###
class SocketWorker extends BasicWorker
  constructor: ->
    super

  ports: []

  hasLogin: (obj)=> obj.user? and obj.password?
  hasAuth: (obj)=>@hasLogin(obj) and @websocket?

  hasAny: (obj)=> @hasLogin(obj) or obj.websocketURL? or @connections>0

  connect: (e)->
    ###
      connects to port
    ###
    super(e)
    @lastPort.onmessage = (e)=>@portHandler(e)
    @sendAuth()

  #onmessage: (e)->  @lastPortHandler(e)


  sendAuth: =>
    ###
      authorizes other clients of this shared webworker
    ###
    message = {}
    if @url? then message.websocketURL = @url
    if @user? then message.user = @user
    if @password? then message.password = @password
    if @websocket? then message.ready = true
    if @hasAny(@) then @postMessage message

  portHandler: (msg) =>
    data = msg.data
    if data.user? then @user = data.user
    if data.password? then @password = data.password
    if data.websocketURL? then @url = data.websocketURL
    unless @websocket?

      if @url? and @hasLogin(@)
        websocket = @createWebsocket(@user,@password,@url)
        @websocket = websocket
        notifyAll = @notifyAll #workaround to avoid "this" context change problems
        websocket.onmessage = notifyAll
        @listenAll (e)->
          #debugger
          websocket.send(e.data)
      ###
      if @url? and @hasLogin(@)
        websocket = @createWebsocket(@user,@password,@url)
        funMes = (e)=>
          event = e
          #debugger
          @notifyAll(e)
        @websocket = websocket

        websocket.onmessage = (e)->funMes(e.data)
        @listenAll (e)->
          #debugger
          websocket.send(e.data)

      ###
    @sendAuth()




worker = new SocketWorker()
self.addEventListener("connect", (e) ->worker.connect(e))


