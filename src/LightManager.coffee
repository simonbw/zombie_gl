POINT_LIGHTS = 6
SPOT_LIGHTS = 1

# Manages allocation of the 8 allowed lights
class window.LightManager

	constructor: (game) ->
		@pointLightRequests = []

		@pointLights = []

		i = 0
		while i < POINT_LIGHTS
			i++
			l = new THREE.PointLight(0xFFFFFF, 1.0, 256)
			@pointLights.push(l)
			l.position.set(10, -10, 10)
			game.scene.add(l)
			console.log "creating pointlight " + i

	update: (game) ->
		# remove disposed
		i = @pointLightRequests.length - 1
		while i >= 0
			if @pointLightRequests[i].disposed
				@pointLightRequests.splice(i, 1)
			i--

		# sort request list
		cx = game.camera.position.x
		cy = game.camera.position.y
		@pointLightRequests.sort (a, b) ->
			distA = (Math.pow(a.position.x - cx, 2) + Math.pow(a.position.y - cy, 2)) 
			distB = (Math.pow(b.position.x - cx, 2) + Math.pow(b.position.y - cy, 2)) 
			return distA - distB

		# # assign lights to the top requested
		i = 0
		while (i < POINT_LIGHTS) && (i < @pointLightRequests.length)
			@pointLightRequests[i].giveLight(@pointLights[i])
			i++
		j = i
		# make sure the rest of the lights are hidden
		while i < POINT_LIGHTS
			l = @pointLights[i]
			l.intensity = 0
			l.distance = 1.0
			i++
		# make sure the rest of the requests don't have a light
		while j < @pointLightRequests.length
			@pointLightRequests[j].removeLight()
			j++

		# Debugging
		# for l in @pointLights
		# 	l.color = 0xFFFFFF
		# 	l.distance = 256
		# 	l.intensity = 1.0

	# Create a new RequestPointLight object
	getPointLight: (x = 0, y = 0, z = 0, intensity = 1.0, distance = 64, color = 0xFFFFFF) ->
		l = new RequestedPointLight(x, y, z, intensity, distance, color)
		@pointLightRequests.push(l)
		return l

# Treat this like a light
class RequestedPointLight
	constructor: (x, y, z, @intensity, @distance, @color) ->
		@disposed = false
		@enabled = true
		@position = new THREE.Vector3(x, y, z)
		@light = null

	giveLight: (light) ->
		@light = light
		@update()

	update: () ->
		if @light
			@light.position.set(@position.x, @position.y, @position.z)
			@light.intensity = @intensity
			@light.distance = @distance
			@light.color.setHex(@color)

	removeLight: ->
		@light = null

	dispose: ->
		@disposed = true
