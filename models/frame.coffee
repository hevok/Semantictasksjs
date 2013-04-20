###
#model for frames loading#
###
class Chat.Search extends Batman.Model
  ###
  contains id and query fields
  ###

  @encode 'id','url'
  ###
    id and url to be stored
  ###


  @persist Batman.SocketStorage
  ###
    searches are stored in socket storage
  ###

  @storageKey: 'frames'

