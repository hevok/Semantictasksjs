###CAKE FILE
This file is to build and test the project
----------
this files makes all coffescript building process
in order to run it you should have coffeescript and cake installed
it can be done by by npm package manager
npm install -g coffee-script
npm install -g cake
###

#a task to explain what this cakefile does, kind of hello world=)
task 'explain', 'Explains what this cakefile does', ->
  console.log 'Ths cake compiles all models to models.js, the same for views and viewmodels'


#child process variable
{exec} = require 'child_process'
asyncblock = require 'asyncblock'

fs           = require 'fs'
path         = require 'path'
#CoffeeScript = require "coffee-script"

existsSync   = fs.existsSync or path.existsSync


execute = (str)->
  exec str, (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

chain = (fun1,fun2) ->
  ###
    executes asynch task
  ###
  f1 = (flow) ->
    fun1()

  return -> asyncblock f1, fun2

bigchain = (arr, ch = null)->
  ###
    executes functions in chain (for synch execution)
  ###
  if arr.length==1
    if(ch==null) then return arr[0] else return chain(arr[0],ch)
  if(ch==null)
    if arr.length==2 then return chain(arr[0],arr[1])
    return bigchain(arr,arr.pop())
  return bigchain arr, chain(arr.pop(),ch)


#VARIABLES
#----------
#path where to take files from
path = "./"
coffees = "*.coffee"


#FUNCTIONS THAT ARE USED IN TASKS
#---------
#testing is described here http://net.tutsplus.com/tutorials/javascript-ajax/better-coffeescript-testing-with-mocha/
test = ->
  console.log "Testing started"

  #testing is described here http://net.tutsplus.com/tutorials/javascript-ajax/better-coffeescript-testing-with-mocha/
  execute "mocha --compilers coffee:coffee-script --ignore-leaks"
 # execute "mocha-phantomjs test/test.html"

  console.log "Testing completed"

#generates docs for sources
#for this command docco ( https://github.com/jashkenas/docco ) should be installed
#
#pygments should also be installed
#in Linux it can be installed by
# sudo easy_install pygments
makeDocs = ->
  console.log "Documentation generation started"

  renderer = "html"
  execute "coffeedoc --renderer #{renderer} chat.coffee Cakefile collab view_models models views test"


  console.log "Documentation generation completed"

#CAKE TASKS TO BE EXECUTED WHEN CALLED cake <taskname>
#-----


withCoffee = (str)->
  if str.indexOf(".coffee")==-1 then str+".coffee" else str


concatStr = (folder,arr, out)->
  str =""
  if folder=="" then folder = "."
  if out.indexOf(".coffee")==-1 then out = out+".coffee"
  for key in arr
    ###writes to str in reverse order###
    str =" #{folder}/#{withCoffee(key)} "+str
  "coffeescript-concat #{str} -o #{withCoffee(out)}"


concat = ->
  ###
  concats coffeescript to make less files for compilation and copies to the js folder when they are compiled
  ###
  root = ""
  test = "test"
  mocks = "#{test}/mocks/"


  collab = "collab/"
  workers = "#{collab}workers/"
  sockets = "#{collab}sockets/"
  routers = "#{collab}routers/"
  channels = "#{collab}channels/"

  models = "models"
  views = "views"
  view_models = "view_models"


  ### copies configuration coffee ###
  execute concatStr("conf", ["chat_conf"] ,"js/chat_conf")

  ### worker for production ###
  execute concatStr(workers, ["abstract_socket_worker","basic_worker","socket_worker"] ,"js/socket_worker")

  makeFakeWorker = (fake)->
    execute concatStr(root, ["#{workers}abstract_socket_worker",mocks+"mock_worker",mocks+fake,workers+"socket_worker"] ,"js/"+fake)


  ### worker for search clientside testing ###
  makeFakeWorker("mock_chat_worker")

  ### worker for clientside chat testing###
  makeFakeWorker("mock_search_worker")

  ### copies chat coffee ###
  execute concatStr(root, ["chat"] ,"js/chat")



  ### concats and copies collab coffees ###
  collabArr = ["#{collab}socket_event",
               "#{sockets}worker_socket","#{sockets}mock_socket","#{sockets}cache_socket",
               "#{channels}channel","#{channels}video_channel",
               "#{routers}simple_router", "#{routers}chat_router",
               "#{collab}socket","#{collab}socket_storage"]

  execute concatStr(root, collabArr ,"js/collab")

  ### concats and copies models coffees ###
  modelsArr = ["user","message","task","search","frame","search_result","graph"]
  execute concatStr("models", modelsArr,"js/models")

  ### concats and copies views coffees ###
  viewsArr = ["user_view","message_view","task_view"]
  execute concatStr(views, viewsArr,"js/views")

  ### concats and copies views_models coffees ###
  view_modelsArr = ["login_view_model","message_board","task_board",
                    "widget_board","video_board","search_board",
                    "search_result_board","frame_board","graph_board"]

  execute concatStr(view_models, view_modelsArr,"js/view_models")


compile = ->
  concat()
  execute "coffee --map --compile js/"


#makes compilation
task 'compile', 'Compiles coffeescript files in the project and moves them to output dir', ->
  compile()

#makes compilation
task 'test', 'Test coffescripts', ->
  test()


#makes docs
task 'make:docs', 'generates docs for sources', ->
  makeDocs()

#makes cleanup,compile and documenting
task 'build', 'Builds project from src/*.coffee to lib/*.js', ->

  console.log "Build task started"

  bigchain([compile,test,makeDocs])()


  console.log "Build task completed"


