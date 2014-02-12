LIFESPAN = 3

LIGHT_RADIUS = 16
LIGHT_INTENSITY = 0.2
LIGHT_COLOR = 0xFFDDAA

class window.MuzzleFlash
	constructor: (@x, @y, @z, @dx, @dy, @vx, @vy) ->
		angle = Math.atan2(@dy, @dx)

		geom = new THREE.Geometry()
		i = 0
		while i < 50
			theta = Random.normal(0.8)
			r = Math.random() * Math.random() * 0.2
			px = Math.cos(angle + theta) * r + Random.normal() * 0.02
			py = Math.sin(angle + theta) * r + Random.normal() * 0.02
			pz = 0
			geom.vertices.push(new THREE.Vector3(px, py, pz))
			i++

		material = new THREE.ParticleSystemMaterial {
			color: 0xFFFFFF,
			size: 0.2,
			map: THREE.ImageUtils.loadTexture("resources/images/particle.png"),
			blending: THREE.AdditiveBlending,
			transparent: true
		}

		@particles = new THREE.ParticleSystem(geom, material)
		@particles.sortParticles = true
		@particles.position.set(@x, @y, @z)

	init: (game) =>
		game.scene.add(@particles)
		@light = game.lightManager.getPointLight(@x, @y, @z)
		@light.intensity = LIGHT_INTENSITY
		@light.color = LIGHT_COLOR
		@light.distance = LIGHT_RADIUS
		@light.update()
		@lifespan = LIFESPAN

	update: (game) =>
		@lifespan--
		if @lifespan <= 0
			game.removeEntity(this)
		else
			@light.intensity = LIGHT_INTENSITY * @lifespan / LIFESPAN
			@light.position.x += @vx
			@light.position.y += @vy
			@light.update()
			@particles.position.x += @vx
			@particles.position.y += @vy

	dispose: (game) =>
		if @disposed
			console.log "removing muzzleFlash twice"
		@disposed = true
		@light.dispose()
		game.scene.remove(@particles)