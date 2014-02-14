
class window.ZombieSpawner
	constructor: (@x, @y, @chance = 1.0) ->

	init: (game) ->
		@mesh = new THREE.Mesh(new THREE.SphereGeometry(0.1, 16, 16), new THREE.MeshBasicMaterial({color:0xFFFFFF, transparent:true, opacity: 0.5}))
		@mesh.position.set(@x, @y, 4)
		game.scene.add(@mesh)

	update: (game) ->
		if (Random.bool(@chance / 60))
			zombie = new Zombie(@x, @y)
			game.addEntity(zombie)