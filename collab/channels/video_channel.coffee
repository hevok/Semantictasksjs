###
  video channel class, temporal version
  will be refactored in the future
###

class Batman.VideoChannel extends Batman.Channel

  peer: null


  ###
    mystream is a temporal global variable to save a stream from a webcam
  ###

  constructor: (name, @room, @myStream = null)->
    super(name)
    @startPeer()

  askWebcam: =>
    @ask "webcam"

  startPeer: (servers=null)=>
    ###
    starts p2p connection
    ###
    @peer = @makePeer()
    @peer.onicecandidate = @onCreateICE


  makePeer:  (servers=null)=>
    if window.RTCPeerConnection?
      new RTCPeerConnection(servers)
    else
      if window.mozRTCPeerConnection?
        new mozRTCPeerConnection(servers)
      else
        new webkitRTCPeerConnection(servers)

  onWebCamSuccess:  (stream)=>
    ###
      when webcam stream received
    ###
    @myStream = stream
    @peer.addStream(stream)
    @fire "localStream", stream
    @peer.onaddstream = @onGetRemoteStream



  call: =>
    ###
      Makes a call
    ###
    if @myStream?
      @peer.createOffer(@onCreateOffer)
    else
      @askWebcam()
      @on "localStream", @call


  onCreateOffer: (desc)=>
    ###
      fires when you propose and offer
    ###
    @peer.setLocalDescription(desc)
    offer = Batman.SocketEvent.makeEvent(desc,@name,"offer",@room)
    @fire "send", offer

  onGetOffer: (event)=>
    ###
      fires when you received another's offer
    ###
    desc = new RTCSessionDescription(event)
    @peer.setRemoteDescription(desc)
    @peer.createAnswer(@onCreateAnswer)


  onCreateAnswer:  (desc)=>
    ###
      fires when you created an answer
    ###
    @peer.setLocalDescription(desc)
    answer = Batman.SocketEvent.makeEvent(desc,@name,"answer",@room)
    @fire "send", answer

  onGetAnswer:  (event)=>
    ###
      fires when you received an answer
    ###
    desc = new RTCSessionDescription(event)
    @peer.setRemoteDescription(desc)

  onGetRemoteStream: (e)=>
    ###
      fires when you got stream
    ###
    if e.stream?
      stream = e.stream
      @fire "remoteStream", stream
    else
      alert "bug in onGetRemoteStream"

  onCreateICE: (event)=>
    ###
      fires when you make an ICE candidates
    ###
    if event.candidate?
      cand = event.candidate
      evt = Batman.SocketEvent.makeEvent(cand,@name,"ICE",@room)
      @fire "send", evt
    ###
    else
      alert "onICE do not work well"
      alert JSON.stringify(event)
    ###

  onGetICE: (event)=>
    ###
      fires when you received and ICE
    ###
    #cand = event.candidate?
    #alert JSON.stringify(event)
    @peer.addIceCandidate(new RTCIceCandidate(event))


  onmessage: (event)=>
    ###
      on message event handler
    ###
    switch event.request
      when "ICE" then @onGetICE(event.content)
      when "offer" then  @onGetOffer(event.content)
      when "answer" then @onGetAnswer(event.content)

  onError: (e)->
    alert "There has been a problem retrieving the streams - did you allow access?"

  stream2src: (stream)=>
    ###
      gets URL from the stream
    ###
    if window.URL?
      window.URL.createObjectURL(stream)
    else
      if window.webkitURL?
        window.webkitURL.createObjectURL(stream)
      else
        if window.mozURL?
          window.mozURL.createObjectURL(stream)
        else
          stream

  subscribeLocal: (vid)=>
    @on "localStream", (stream)=>vid.src = @stream2src(stream)

  subscribeRemote: (vid)=>
    @on "remoteStream", (stream)=>vid.src = @stream2src(stream)



  attach: (obj)=>
    onStream = @onWebCamSuccess
    obj.on "localStream", onStream
    super(obj)
    if @myStream?
      @peer.addStream(@myStream)
      @peer.onaddstream = @onGetRemoteStream
    else
      @askWebcam()
    @

