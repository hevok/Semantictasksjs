###
# MockSocket class #
Mock socket is needed for tests to simulate websocket behaviour
###

#_require channel.coffee
#_require socket_event.coffee


class Batman.CacheSocket extends Batman.Object
	###
	#Cache socket#
	Cache socket is needed to collect the data before real websocket is connected
	###

	constructor: (@url)->
		@input = new Array()
		super

	isMock: true
	isCache: true
	input: []

	send: (data)=>@input.push(data)

	onopen: ->
		###
		Open event
		###
		console.log "open"

	onmessage: (event)->
		###
		On message
		###
		data = event.data
		console.log(data)

	onerror: =>
		console.log "error"

	onclose: =>
		console.log "close"

	randomInt: (min, max)=>
		###
			random int generating function
		###
		Math.floor(Math.random() * (max - min + 1)) + min

	unapply: (successor)=>
		if(@input? and successor.send?)
			for el in @input then successor.send(el)

