onLogin = (data)=>
  graph = Viva.Graph.graph()
  graph.addLink(1, 2)
  graph.addLink(2, 3)

  cont = $("#graph").get(0)

  params =
    container: cont

  renderer = Viva.Graph.View.renderer(graph, params)
  renderer.run()

Chat.on "login", onLogin
