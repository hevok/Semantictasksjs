jQuery ->
  gridster = $(".gridster ul").gridster().data('gridster');
  myvid = $ "#myvideo"
  othervid1 = $ "#othervideo1"
  othervid2 = $ "#othervideo2"

  gridster.add_widget(othervid1, 1, 1, 1, 1)
  gridster.add_widget(othervid2, 1, 1, 2, 1)
  gridster.add_widget(myvid, 1, 1, 3, 1)
