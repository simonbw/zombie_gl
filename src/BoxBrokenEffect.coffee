PARTICLE_COUNT = 2 << 10
GRAVITY = 9.8 / (60)
DRAG = 0.99
FADE = 0.01
LIFESPAN = 150
EXPLOSION_FORCE = 3.0

class window.BoxBrokenEffect

	@material = new THREE.MeshPhongMaterial {
		# color: 0x77664B,
		side: THREE.DoubleSide,
		map: Box.texture,
		bumpMap: Box.bumpMap,
		bumpScale: 0.02
	}

	constructor: (@x, @y, @angle) ->
		@lifespan = LIFESPAN
		@meshes = []
		@velocities = []
		@spins = []

		@meshContainer = new THREE.Object3D()
		@meshContainer.position.set(@x, @y, Box.SIZE / 2)
		@meshContainer.rotation.z = @angle
		size = Box.SIZE
		for i in [0...6]
			geometry = new THREE.PlaneGeometry(size, size)
			mesh = new THREE.Mesh(geometry, BoxBrokenEffect.material)
			@meshes.push(mesh)
			@meshContainer.add(mesh)
			@velocities.push(new THREE.Vector3())
			@spins.push(new THREE.Vector3())

		# top
		@meshes[0].position.z = size / 2
		# bottom
		@meshes[5].position.z = -size / 2

		# right
		@meshes[1].position.x = size / 2
		@meshes[1].rotation.y = Math.PI / 2

		# left
		@meshes[2].position.x = -size / 2
		@meshes[2].rotation.y = -Math.PI / 2

		# front
		@meshes[3].position.y = size / 2
		@meshes[3].rotation.x = Math.PI / 2

		# back
		@meshes[4].position.y = -size / 2
		@meshes[4].rotation.x = -Math.PI / 2

		@velocities[0].x = Random.normal(1.0)
		@velocities[0].y = Random.normal(1.0)
		@velocities[0].z = Math.random() * 2 + 3.0
		@spins[0].z = Random.normal(0.05)


	init: (game) =>
		game.scene.add(@meshContainer)

	update: (game) =>
		if @meshes[0].position.z > 0.0001
			@velocities[0].z -= GRAVITY
			@velocities[0].x *= 0.9998
			@velocities[0].y *= 0.9998
			@spins[0].z *= 0.99
		else 
			@velocities[0].z = 0
			@velocities[0].x *= 0.94
			@velocities[0].y *= 0.94
			@meshes[0].position.z = 0.00005
			@spins[0].z *= 0.94

		for i in [0...@meshes.length]
			mesh = @meshes[i]
			mesh.position.x += @velocities[i].x / 60
			mesh.position.y += @velocities[i].y / 60
			mesh.position.z += @velocities[i].z / 60
			mesh.rotation.x += @spins[i].x
			mesh.rotation.y += @spins[i].y
			mesh.rotation.z += @spins[i].z

		@lifespan--
		if @lifespan <= 0
			game.removeEntity(this)

	dispose: (game) =>
		if @disposed
			console.log "removing HitEffect twice"
		@disposed = true
		game.scene.remove(@meshContainer)
