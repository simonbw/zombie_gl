class window.SoundManager
    constructor: (game) ->
        @context = new (window.AudioContext || window.webkitAudioContext)();
        @buffers = {}
        if (!@context)
            alert("No context support")
        else
            @output = @context.createGain()
            @output.connect(@context.destination)
            @output.gain.value = 1.0
            @loadSound('gun_empty')

            @loadSound('pistol_shot')
            @loadSound('pistol_reload')
            @loadSound('pistol_reload_finish')

            @loadSound('rifle_shot')
            @loadSound('rifle_reload')
            @loadSound('rifle_reload_finish')

    loadSound: (name) ->
        request = new XMLHttpRequest()
        request.responseType = 'arraybuffer'
        request.open('GET', "resources/sounds/#{name}.wav", true)
        onDecode = (buffer) =>
            @buffers[name] = buffer
        onError = (error) =>
            alert(error)
        request.onload = =>
            @context.decodeAudioData(request.response, onDecode, onError)
        request.send()

    playSound: (name) ->
        if @buffers[name]
            source = @context.createBufferSource()
            source.buffer = @buffers[name]
            source.connect(@output)
            source.start(0)
        else
            console.log "sound #{name} not loaded"
