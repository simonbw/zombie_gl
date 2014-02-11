# Imports
b2Vec2 = Box2D.Common.Math.b2Vec2;
b2BodyDef = Box2D.Dynamics.b2BodyDef;
b2Body = Box2D.Dynamics.b2Body;
b2FixtureDef = Box2D.Dynamics.b2FixtureDef;
b2Fixture = Box2D.Dynamics.b2Fixture;
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;
b2DebugDraw = Box2D.Dynamics.b2DebugDraw;
b2World = Box2D.Dynamics.b2World

# Constants
FRAMERATE = 60.0
PHYSICS_STEPS = 3

class window.Game
	constructor: () ->
		console.log("Created New Game")

	start: =>
		console.log("Starting Game")
		@updateList = []
		@updateList2 = []
		@toRemove = []
		@io = new IO()
		@world = new b2World(new b2Vec2(0, 0), true)
		Box2D.Common.b2Settings.b2_maxTranslation = 5.0

		@renderer = new THREE.WebGLRenderer({antialias:true})
		@renderer.setSize window.innerWidth, window.innerHeight
		window.document.body.appendChild(@renderer.domElement)

		@scene = new THREE.Scene()
		@camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 20000)
		@scene.add(@camera)
		@camera.position.set(0, 0, 20)
		@camera.lookAt({x:0, y:0, z:0})
		
		window.addEventListener 'resize', =>
			@renderer.setSize window.innerWidth, window.innerHeight
			@camera.aspect = window.innerWidth / window.innerHeight
			@camera.updateProjectionMatrix()

		@lightManager = new LightManager(this)
		@soundManager = new SoundManager(this)
		
		listener = new Box2D.Dynamics.b2ContactListener()
		listener.BeginContact = (contact) =>
			a = contact.GetFixtureA().GetBody().GetUserData()
			b = contact.GetFixtureB().GetBody().GetUserData()

			hit = false
			if a && a.hit
				hit = a.hit(this, b)
			if b && b.hit
				hit = hit || b.hit(this, a)

			if hit
				contact.SetEnabled(false)
		@world.SetContactListener(listener)

		# ================================ #
		# ----------- ENTITIES ----------- #
		# ================================ #

		@player = @addEntity(new Player())
		@addEntity(new Building(100, 0))
		@addEntity(new Building(-100, 0))
		@addEntity(new Building(-100, 100))
		@addEntity(new Building(-100, -100))
		@addEntity(new Building(100, -100))
		@addEntity(new Building(100, 100))
		@addEntity(new Ground(0, 0))
		@addEntity(new Ground(500, 0))
		@addEntity(new Ground(500, 500))
		@addEntity(new Ground(0, 500))
		@addEntity(new Ground(-500, 500))
		@addEntity(new Ground(-500, 0))
		@addEntity(new Ground(-500, -500))
		@addEntity(new Ground(0, -500))
		@addEntity(new Ground(500, -500))

		@addEntity(new Box(20, 0))

		@addEntity(new StreetLight(50, 0))
		@addEntity(new StreetLight(50, 50))
		console.log("Game Started Successfully")
		@update()

	addEntity: (entity) =>
		if (entity.init)
			entity.init(this)
		if (entity.update)
			@updateList.push(entity)
		if (entity.update2)
			@updateList2.push(entity)
		return entity

	removeEntity: (entity) =>
		if (entity.update || entity.update2 || entity.dispose)
			@toRemove.push(entity)
		return entity

	removalPass: =>
		for entity in @toRemove
			if entity.update
				@updateList.splice(@updateList.indexOf(entity), 1)
			if entity.update2
				@updateList2.splice(@updateList.indexOf(entity), 1)
			if entity.dispose
				entity.dispose(this)
		@toRemove = []
		
	update: () =>
		window.requestAnimationFrame(@update)
		@render()

		@io.update()
		if @io.moveX != 0
			n = 100
			# console.log @io.moveX

		i = 0
		while i < PHYSICS_STEPS
			i++
			@world.Step(1 / (FRAMERATE * PHYSICS_STEPS), 3, 3)
			@removalPass()

		for entity in @updateList
			entity.update(this)
		
		@removalPass()

		for entity in @updateList2
			entity.update2(this)		
		
		@removalPass()

		@camera.position.x = 0.9 * @camera.position.x + 0.1 * @player.mesh.position.x
		@camera.position.y = 0.9 * @camera.position.y + 0.1 * @player.mesh.position.y
		@camera.position.z += -@camera.position.z * @io.zoom * 0.01

		@lightManager.update(this)

	render: () =>
		@renderer.render(@scene, @camera)
