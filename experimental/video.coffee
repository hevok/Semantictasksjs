jQuery ->

  video = document.getElementById('mywebcam');
  video.autoplay = true

  videoOther = document.getElementById('webcam1');
  videoOther.autoplay = true


  getWebCam = ->
    navigator.getUserMedia or (navigator.getUserMedia = navigator.mozGetUserMedia or navigator.webkitGetUserMedia or navigator.msGetUserMedia)
    if navigator.getUserMedia
      navigator.getUserMedia
        video: true
        audio: true
      , onWebCamSuccess, onError
    else
      alert "getUserMedia is not supported in this browser."

  onWebCamSuccess = (stream)->
    stream2Vid(video,stream)
    #stream2Vid(videoOther,stream)
    peerMe.addStream(stream)
    peerMe.createOffer(onOffer)

  onError = ->
    alert "There has been a problem retrieving the streams - did you allow access?"

  myIceCallback = (event) ->
    if event.candidate?
      peerOther.addIceCandidate new RTCIceCandidate(event.candidate)

  otherIceCallback = (event) ->
    if event.candidate?
      peerMe.addIceCandidate new RTCIceCandidate(event.candidate)


  onOffer =(desc)->
    peerMe.setLocalDescription(desc)
    peerOther.setRemoteDescription(desc)
    peerOther.createAnswer(onAnswer)

  onAnswer = (desc)->
    peerOther.setLocalDescription(desc)
    peerMe.setRemoteDescription(desc)

  makePeer = (servers=null)->
    if window.RTCPeerConnection?
      new RTCPeerConnection(servers)
    else
      if window.mozRTCPeerConnection?
        new mozRTCPeerConnection(servers)
      else
        new webkitRTCPeerConnection(servers)

  stream2Vid =  (vid,stream)=>
    if window.webkitURL?
      videoSource = window.webkitURL.createObjectURL(stream)
    else
      videoSource = stream
    vid.src = videoSource

  gotRemoteStream = (e)->
    stream2Vid(videoOther,e.stream)
    #videoOther.src = webkitURL.createObjectURL(e.stream)





  peerMe = makePeer()
  peerOther = makePeer()

  peerMe.onicecandidate = myIceCallback;
  peerOther.onicecandidate = otherIceCallback
  peerOther.onaddstream = gotRemoteStream

  getWebCam()