PARTICLE_COUNT = 2 << 10
GRAVITY = 9.8 / (60)
DRAG = 0.99
FADE = 0.01
LIFESPAN = 150
EXPLOSION_FORCE = 3.0

class window.BoxBrokenEffect
		
	constructor: (@x, @y, @angle) ->
		@lifespan = LIFESPAN
		@geom = new THREE.BufferGeometry()
		@geom.dynamic = true
		@geom.attributes = {
			position: {
				itemSize: 3,
				array: new Float32Array(PARTICLE_COUNT * 3),
				numItems: PARTICLE_COUNT * 3
			},
			velocity: {
				itemSize: 3,
				array: new Float32Array(PARTICLE_COUNT * 3),
				numItems: PARTICLE_COUNT * 3
			},
			color: {
				itemSize: 3,
				array: new Float32Array(PARTICLE_COUNT * 3),
				numItems: PARTICLE_COUNT * 3
			},
		};

		positions = @geom.attributes.position.array
		velocities = @geom.attributes.velocity.array
		colors = @geom.attributes.color.array
		i = 0
		while i < PARTICLE_COUNT * 3
			positions[i] = (Math.random() - 0.5) * Box.SIZE
			positions[i + 1] = (Math.random() - 0.5) * Box.SIZE
			positions[i + 2] = (Math.random() - 0.5) * Box.SIZE
			velocities[i] = Random.normal(EXPLOSION_FORCE)
			velocities[i + 1] = Random.normal(EXPLOSION_FORCE)
			velocities[i + 2] = Random.normal(EXPLOSION_FORCE)
			colors[i] = 0.35 + Math.random() * 0.4
			colors[i + 1] = 0.3 + Math.random() * 0.3
			colors[i + 2] = 0.2 + Math.random() * 0.2
			i += 3
		@geom.computeBoundingSphere()
		colors = @geom.attributes.color.needsUpdate = true

		texture = THREE.ImageUtils.loadTexture("resources/images/wood_hit.png")

		@material = new THREE.ParticleSystemMaterial {
			# color: 0x77664B,
			vertexColors: THREE.VertexColors,
			size: 0.02,
			# map: texture,
			# blending: THREE.AdditiveBlending,
			transparent: true
		}
		@material.depthWrite = false

		@particles = new THREE.ParticleSystem(@geom, @material)
		@particles.sortParticles = true
		@particles.position.set(@x, @y, Box.SIZE / 2)
		@particles.rotation.z = @angle

	init: (game) =>
		game.scene.add(@particles)

	update: (game) =>
		positions = @geom.attributes.position.array
		velocities = @geom.attributes.velocity.array
		i = 0
		while i < PARTICLE_COUNT * 3
			positions[i] += velocities[i] / 60
			positions[i + 1] += velocities[i + 1] / 60
			positions[i + 2] += velocities[i + 2] / 60
			velocities[i] *= DRAG
			velocities[i + 1] *= DRAG
			velocities[i + 2] *= DRAG
			velocities[i + 2] -= GRAVITY
			if positions[i + 2] <= -Box.SIZE / 2
				positions[i + 2] = -Box.SIZE / 2 + 0.0001
				velocities[i + 2] *= -0.5
				velocities[i] *= 0.5
				velocities[i + 1] *= 0.5
				if Math.abs(velocities[i]) < 0.001
					velocities[i] = 0
				if Math.abs(velocities[i + 1]) < 0.001
					velocities[i + 1] = 0
				if Math.abs(velocities[i + 2]) < 0.001
					velocities[i + 2] = 0
			i += 3
		@geom.attributes.position.needsUpdate = true
		@geom.attributes.velocity.needsUpdate = true
		@geom.computeBoundingSphere()
		
		@material.opacity = Math.min(2.0 * @lifespan / LIFESPAN, 1.0)
		
		@lifespan--
		if @lifespan <= 0
			game.removeEntity(this)

	dispose: (game) =>
		if @disposed
			console.log "removing HitEffect twice"
		@disposed = true
		game.scene.remove(@particles)
