LIGHT_RADIUS = 4
LIGHT_INTENSITY = 0.10
LIGHT_COLOR = 0xFFFFFF

PARTICLE_COUNT = 8
GRAVITY = 9.8 / (60)
DRAG = 0.99
FADE = 0.01
LIFESPAN = 15
LIGHT_LIFESPAN = 6

class window.HitEffect
		
	constructor: (@x, @y, @z, type = "concrete") ->
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
		};

		positions = @geom.attributes.position.array
		velocities = @geom.attributes.velocity.array
		i = 0
		while i < PARTICLE_COUNT * 3
			positions[i] = Random.normal(0.05)
			positions[i + 1] = Random.normal(0.05)
			positions[i + 2] = Random.normal(0.05)
			velocities[i] = positions[i] * 140
			velocities[i + 1] = positions[i + 1] * 140 
			velocities[i + 2] = positions[i + 2] * 35
			i += 3
		@geom.computeBoundingSphere()

		texture = null
		if type == "metal"
			texture = THREE.ImageUtils.loadTexture("resources/images/metal_hit.png")
		else if type == "flesh"
			texture = THREE.ImageUtils.loadTexture("resources/images/flesh_hit.png")
		else if type == "concrete"
			texture = THREE.ImageUtils.loadTexture("resources/images/concrete_hit.png")
		else if type == "wood"
			texture = THREE.ImageUtils.loadTexture("resources/images/wood_hit.png")
		else 
			texture = THREE.ImageUtils.loadTexture("resources/images/generic_hit.png")

		@material = new THREE.ParticleSystemMaterial {
			# color: 0xFFFFFF,
			size: 0.3,
			map: texture,
			blending: THREE.AdditiveBlending,
			transparent: true
		}
		@material.depthWrite = false

		@particles = new THREE.ParticleSystem(@geom, @material)
		@particles.sortParticles = true
		@particles.position.set(@x, @y, @z)

	init: (game) =>
		game.scene.add(@particles)

		@light = game.lightManager.getPointLight(@x, @y, @z)
		@light.intensity = LIGHT_INTENSITY
		@light.color = LIGHT_COLOR
		@light.distance = LIGHT_RADIUS
		@light.update()

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
			i += 3
		@geom.attributes.position.needsUpdate = true
		@geom.attributes.velocity.needsUpdate = true
		@geom.computeBoundingSphere()
		
		@material.opacity = @lifespan / LIFESPAN
		
		@light.intensity = Math.max(LIGHT_INTENSITY * (@lifespan - (LIFESPAN - LIGHT_LIFESPAN)) / LIGHT_LIFESPAN, 0.0)
		@light.update()
		
		@lifespan--
		if @lifespan <= 0
			game.removeEntity(this)

	dispose: (game) =>
		if @disposed
			console.log "removing HitEffect twice"
		@disposed = true
		game.scene.remove(@particles)
		@light.dispose()
