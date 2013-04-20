###
JUST AN ALTERNATIVE VERSION OF CAKEFILE IN CASE I WILL COME BACK TO IT SOMEWHEN
###

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


execute = (str)->
  exec str, (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

#VARIABLES
#----------
#path where to take files from
path = "./"
coffees = "*.coffee"

#use rehab for better file joints
#Rehab = require 'rehab'


###BUILDER

  helpful class for our biuild process
  can compile and generate docs for itself
###

class Builder

  @all: []

  #assigns basic params

  constructor: (@path, input, output)->
    @input = @path+input
    @output = @path+output
    Builder.all.push(@)

  compileStr:-> "coffee --compile --map  --output #{@output} #{@input}"

  #compiles and joins models in single js file
  compile: -> execute @compileStr()

class FolderBuilder extends Builder
  constructor: (@path, input, output, fileName="")->
    super(@path, input,output)
    if fileName!="" then @fileName = @output+fileName else @fileName = ""
   # FolderBuilder.all.push(@)

  join: -> if @fileName != "" then  "--join #{@fileName}" else ""

  compileStr: => "coffee #{@join()} --compile --map --output #{@output} #{@input}"

  #BUGGY!
  makeDoco: => execute("docco #{@input}/#{coffees}")

  makeCoffeeDoc: (renderer="html")=>
    command = "coffeedoc --renderer #{renderer} #{@input}/#{coffees}"
    execute command
 ###
  compile: =>
    files = new Rehab().process @input
    to_single_file = "--join #{@output}"
    from_files = "--compile #{files.join ' '}"
    execute "coffee #{to_single_file} #{from_files}"
 ###

appBuilder = new Builder(path,"chat.coffee","js/")
collabBuilder = new FolderBuilder(path, "collab", "js/","collab.js")
modelsBuilder = new FolderBuilder(path, "models", "js/", "models.js")
viewsBuilder = new FolderBuilder(path, "views", "js/","views.js")
viewModelsBuilder = new FolderBuilder(path, "view_models", "js/", "view_models.js")
mockBuilder = new Builder(path,"mock_data.coffee","js/")
modelsBuilder = new FolderBuilder(path, "models", "js/", "models.js")



#FUNCTIONS THAT ARE USED IN TASKS
#---------
#testing is described here http://net.tutsplus.com/tutorials/javascript-ajax/better-coffeescript-testing-with-mocha/
test = ->
  console.log "Testing started"

  #testing is described here http://net.tutsplus.com/tutorials/javascript-ajax/better-coffeescript-testing-with-mocha/
  execute "mocha --compilers coffee:coffee-script --ignore-leaks"
 # execute "mocha-phantomjs test/test.html"

  console.log "Testing completed"


compile = ->
  console.log "Compilation started"
  for builder in Builder.all
    builder.compile()
  console.log "Compilation completed"

#generates docs for sources
#for this command docco ( https://github.com/jashkenas/docco ) should be installed
#
#pygments should also be installed
#in Linux it can be installed by
# sudo easy_install pygments
makeDocs = ->
  console.log "Documentation generation started"

  renderer = "html"
  execute "coffeedoc --renderer #{renderer} chat.coffee mock_data.coffee Cakefile collab view_models models views test"


  console.log "Documentation generation completed"

#CAKE TASKS TO BE EXECUTED WHEN CALLED cake <taskname>
#-----


#makes compilation
task 'compile', 'Compiles coffeescript files in the project and moves them to output dir', ->
  compile()

#makes compilation
task 'test', 'Test coffescripts', ->
  test()


#makes docs
task 'make:docs', 'generates docs for sources', ->
  makeDocs()

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
  needed for debugging compile
  ###

  ### copies chat coffee ###
  execute concatStr("", ["chat"] ,"js/chat")

  ### concats and copies collab coffees ###
  collabArr = ["socket_event", "mock_socket","channel", "simple_router", "chat_router", "socket","socket_storage"]
  execute concatStr("collab", collabArr ,"js/collab")

  ### concats and copies models coffees ###
  modelsArr = ["user","message","task"]
  execute concatStr("models", modelsArr,"js/models")


  ### concats and copies views coffees ###
  viewsArr = ["user_view","message_view","task_view"]
  execute concatStr("views", viewsArr,"js/views")

  ### concats and copies views_models coffees ###
  view_modelsArr = ["login_view_model","message_board","task_board","widget_board","video_board"]
  execute concatStr("view_models", view_modelsArr,"js/view_models")

  ### copies mock coffee ###
  execute concatStr("", ["mock"] ,"js/mock")

debugCompile = ->
  concat()
  execute "coffee --map --compile js/"

#makes cleanup,compile and documenting
task 'build', 'Builds project from src/*.coffee to lib/*.js', ->
  console.log "Build task started"

  #compile()
  debugCompile()
  test()

  makeDocs()

  console.log "Build task completed"


