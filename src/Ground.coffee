# Imports

# Constants
SIZE = 500.0

class window.Ground
	constructor: (x, y) ->
		@mesh = new THREE.Mesh(new THREE.PlaneGeometry(SIZE, SIZE, 1, 1), new THREE.MeshPhongMaterial({
			color: 0x777777,
			specular: 0x777777,
			shininess: 0
			}))
		@mesh.position.set(x, y, 0)
		
		# @mesh.receiveShadow = true

	init: (game) ->
		# Graphics
		game.scene.add(@mesh)