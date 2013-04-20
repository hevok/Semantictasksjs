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