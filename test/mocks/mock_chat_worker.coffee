class BasicWorker extends MockWorker
  ###
    It is mockworker created to test the chat data
  ###
  constructor: ->
    super()
    robot =
      data:
        content:
          text: 'I am still alive!'
          user: "Robot"
        request: "push"
        channel: "messages"

    mycode =
      data:
        content:
          text:"Hi, guys! Look at my code!"
          user:"Anton"
        request: "push"
        channel: "messages"
    focus =
      data:
        content:
          text: "Comrades, it is not our primary focus, let's go and continue writing grant application!"
          user: "coced"
    @arr = [robot, mycode, focus]
