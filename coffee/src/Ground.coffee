# Imports

# Constants
SIZE = 500.0

class window.Ground
	constructor: (x, y) ->
		texture = new THREE.ImageUtils.loadTexture("resources/images/ground.png")
		texture.wrapS = THREE.RepeatWrapping
		texture.wrapT = THREE.RepeatWrapping
		texture.repeat.set(50, 50)
		material = new THREE.MeshPhongMaterial {
			color: 0x555555,
			specular: 0x777777,
			# map: texture,
			bumpMap: texture,
			bumpScale: 0.01,
			shininess: 0
		}
		@mesh = new THREE.Mesh(new THREE.PlaneGeometry(SIZE, SIZE, 1, 1), material)
		@mesh.position.set(x, y, 0)
		
		# @mesh.receiveShadow = true

	init: (game) ->
		# Graphics
		game.scene.add(@mesh)