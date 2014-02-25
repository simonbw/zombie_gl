

MODELS = ["zombie", "player"]

class window.Models

	@models = {}
	@init: (@callback) ->
		Models.next(null)

	@next: (geometry, materials) =>
		if (geometry || materials)
			name = MODELS.pop()
			console.log "loaded #{name}"
			if !materials
				materials = [new THREE.MeshLambertMaterial()]
			Models.models[name] = {'geometry': geometry, 'materials': materials}
		
		if MODELS.length > 0
			name = MODELS[MODELS.length - 1]
			console.log "loading #{name}"
			loader = new THREE.JSONLoader();
			loader.load "resources/models/#{name}.js", @next
		else
			@callback()

