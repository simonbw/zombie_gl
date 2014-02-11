



class window.SoundManager
	constructor: (game) ->
		@context = new (window.AudioContext || window.webkitAudioContext)();
		@buffers = {}
		if (!@context)
			alert("No context support")

		@loadSound('pistol_shot')

	loadSound: (name) ->
		request = new XMLHttpRequest()
		request.responseType = 'arraybuffer'
		request.open('GET', "resources/sounds/#{name}.wav", true)
		onDecode = (buffer) =>
			@buffers[name] = buffer
			console.log "sound #{name} loaded"
		onError = (error) =>
			alert(error)
		request.onload = =>
			@context.decodeAudioData(request.response, onDecode, onError)
		request.send()

	playSound: (name) ->
		source = @context.createBufferSource()
		source.buffer = @buffers[name]
		source.connect(@context.destination)
		source.start(0)