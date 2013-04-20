jQuery ->
  gridster = $(".gridster ul").gridster().data('gridster');
  users = $ "#userboard"
  messages = $ "#messageboard"
  tasks = $ "#taskboard"
  frame = $ "#frameboard"
  graph = $ "#graphboard"
  search = $ "#searchboard"

  myvid = $ "#myvideo"
  othervid1 = $ "#othervideo1"
  othervid2 = $ "#othervideo2"

  gridster.add_widget(othervid1, 1, 1, 1, 1)
  gridster.add_widget(othervid2, 1, 1, 2, 1)
  gridster.add_widget(myvid, 1, 1, 3, 1)

  gridster.add_widget(search, 1, 1, 1, 3)
  gridster.add_widget(graph, 2, 2, 1, 2)


  gridster.add_widget(messages, 1, 2, 3, 2)
  gridster.add_widget(tasks, 1, 2, 3, 4)

  #gridster.add_widget(users, 1, 2, 4, 1);
  #gridster.add_widget(frame, 3, 3, 1, 5);

