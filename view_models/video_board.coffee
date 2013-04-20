class Chat.VideoBoard extends Batman.Object

  video: null
  videoOther1: null
  videoOther2: null
  instance: null

  constructor: ->
    ###
      receives elements
    ###
    @video = document.getElementById('mywebcam');
    @video.autoplay = true

    @videoOther1 = document.getElementById('webcam1');
    @videoOther1.autoplay = true

  loginHandler: (data)->
    ###
      creates two test videos
    ###
    socket = Batman.Socket.getInstance()
    first2second = socket.getVideoChannel("myvideo","othervideo1")
    first2second.subscribeLocal(@video)
    first2second.subscribeRemote(@videoOther1)
    first2second.call()

Chat.on "login", (data)=>
  unless Chat.VideoBoard.instance? then Chat.VideoBoard.instance =new Chat.VideoBoard()
  Chat.VideoBoard.instance.loginHandler(data)