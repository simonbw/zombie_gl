Vec2 = Box2D.Common.Math.b2Vec2

class window.Zombie
	constructor: ->
		@mesh = new THREE.Mesh(new THREE.SphereGeometry(10, 32, 32), new THREE.MeshLambertMaterial({color: 0xDD0000}))
	
	init: (game) ->
		game.scene.add(@mesh)

	update: ->
		@mesh.position.x += 0.1

