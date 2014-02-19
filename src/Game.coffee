# Imports
b2Vec2 = Box2D.Common.Math.b2Vec2
b2BodyDef = Box2D.Dynamics.b2BodyDef
b2Body = Box2D.Dynamics.b2Body
b2FixtureDef = Box2D.Dynamics.b2FixtureDef
b2Fixture = Box2D.Dynamics.b2Fixture
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
b2DebugDraw = Box2D.Dynamics.b2DebugDraw
b2World = Box2D.Dynamics.b2World

# Constants
FRAMERATE = 60.0
PHYSICS_STEPS = 3

class window.Game
	constructor: () ->
		@io = new IO(this)
		Box2D.Common.b2Settings.b2_maxTranslation = 5.0
		@stats = new Stats()
		@renderer = new THREE.WebGLRenderer({antialias:true})
		@renderer.setSize window.innerWidth, window.innerHeight
		window.document.body.appendChild(@renderer.domElement)

		window.addEventListener 'resize', =>
			@renderer.setSize window.innerWidth, window.innerHeight
			@camera.aspect = window.innerWidth / window.innerHeight
			@camera.updateProjectionMatrix()

		@lightManager = new LightManager(this)
		@soundManager = new SoundManager(this)
	
	initWorld: ->
		# cleanup
		if @world
			for body in @world.GetBodyList()
				@world.DestroyBody(body)
		
		# make new world
		@world = new b2World(new b2Vec2(0, 0), true)
		listener = new Box2D.Dynamics.b2ContactListener()
		listener.BeginContact = (contact) =>
			a = contact.GetFixtureA().GetBody().GetUserData()
			b = contact.GetFixtureB().GetBody().GetUserData()

			hit = false
			if a && a.hit
				hit = a.hit(this, b)
			if b && b.hit
				hit = b.hit(this, a) || hit

			# if hit
			# 	contact.SetEnabled(false)
		listener.PostSolve = (contact, impulse) =>
			a = contact.GetFixtureA().GetBody().GetUserData()
			b = contact.GetFixtureB().GetBody().GetUserData()

			if a && a.hit2
				a.hit2(this, b, impulse)
			if b && b.hit2
				b.hit2(this, a, impulse)
		@world.SetContactListener(listener)

	initScene: ->
		@scene = new THREE.Scene()
		@camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 20000)
		@scene.add(@camera)
		@camera.position.set(0, 0, 20)
		@camera.lookAt({x:0, y:0, z:0})

		@lightManager.reset(this)

	start: =>
		if @request
			window.cancelAnimationFrame(@request)

		@stats.newGame()
		
		@preUpdateList = []
		@updateList = []
		@postUpdateList = []
		@toRemove = []

		@initWorld()
		@initScene()

		@player = @addEntity(new Player(0, 1))
		@addEntity(new Ground(0, 0))
		@addEntity(new StreetLight(0, 0))
		@addEntity(new StreetLight(0, -17.5))
		@addEntity(new StreetLight(0, 17.5))

		@addEntity(new Building(10, -25))
		@addEntity(new Building(10, -10))
		@addEntity(new Building(10, 0))
		@addEntity(new Building(10, 10))
		@addEntity(new Building(10, 25))
		@addEntity(new Building(5, -40))
		@addEntity(new Building(15, -40))
		@addEntity(new Building(25, -30))
		@addEntity(new Building(25, -20))
		@addEntity(new Building(25, -10))
		@addEntity(new Building(25, 0))
		@addEntity(new Building(25, 10))
		@addEntity(new Building(25, 20))
		@addEntity(new Building(25, 30))
		@addEntity(new Building(15, 40))
		@addEntity(new Building(5, 40))

		@addEntity(new Building(-10, -25))
		@addEntity(new Building(-10, -10))
		@addEntity(new Building(-10, 0))
		@addEntity(new Building(-10, 10))
		@addEntity(new Building(-10, 25))
		@addEntity(new Building(-5, -40))
		@addEntity(new Building(-15, -40))
		@addEntity(new Building(-25, -30))
		@addEntity(new Building(-25, -20))
		@addEntity(new Building(-25, -10))
		@addEntity(new Building(-25, 0))
		@addEntity(new Building(-25, 10))
		@addEntity(new Building(-25, 20))
		@addEntity(new Building(-25, 30))
		@addEntity(new Building(-15, 40))
		@addEntity(new Building(-5, 40))


		# @addEntity(new ZombieSpawner(0, 18, 0.1))
		# @addEntity(new ZombieSpawner(0, -18, 0.1))

		# corners
		@addEntity(new ZombieSpawner(17.5, 32.5, 0.1))
		@addEntity(new ZombieSpawner(17.5, -32.5, 0.1))
		@addEntity(new ZombieSpawner(-17.5, 32.5, 0.1))
		@addEntity(new ZombieSpawner(-17.5, -32.5, 0.1))

		for i in [1...11]
			@addEntity(new Box(2, i * 3))
			@addEntity(new Box(-2, i * 3))
			@addEntity(new Box(2, -i * 3))
			@addEntity(new Box(-2, -i * 3))

			@addEntity(new Box(17.5, i * 3))
			@addEntity(new Box(-17.5, i * 3))
			@addEntity(new Box(17.5, -i * 3))
			@addEntity(new Box(-17.5, -i * 3))

		@update()

	addEntity: (entity) =>
		if (entity.init)
			entity.init(this)
		if (entity.update)
			@updateList.push(entity)
		if (entity.preUpdate)
			@preUpdateList.push(entity)
		if (entity.postUpdate)
			@postUpdateList.push(entity)
		return entity

	removeEntity: (entity) =>
		if !entity.alreadyRemoved && (entity.update || entity.preUpdate || entity.postUpdate || entity.dispose)
			entity.alreadyRemoved = true
			@toRemove.push(entity)
		return entity

	removalPass: =>
		for entity in @toRemove
			if entity.update
				@updateList.splice(@updateList.indexOf(entity), 1)
			if entity.preUpdate
				@preUpdateList.splice(@preUpdateList.indexOf(entity), 1)
			if entity.postUpdate
				@postUpdateList.splice(@postUpdateList.indexOf(entity), 1)
			if entity.dispose
				entity.dispose(this)
		@toRemove = []
		
	update: =>
		@request = window.requestAnimationFrame(@update)
		@render()

		@io.update()

		for entity in @preUpdateList
			entity.preUpdate(this)

		@removalPass()

		i = 0
		while i < PHYSICS_STEPS
			i++
			@world.Step(1 / (FRAMERATE * PHYSICS_STEPS), 3, 3)
			@removalPass()
		@world.ClearForces()

		for entity in @updateList
			entity.update(this)
		
		@removalPass()

		for entity in @postUpdateList
			entity.postUpdate(this)
		
		@removalPass()

		@camera.position.x = 0.9 * @camera.position.x + 0.1 * @player.mesh.position.x
		@camera.position.y = 0.9 * @camera.position.y + 0.1 * @player.mesh.position.y
		@camera.position.z += -@camera.position.z * @io.zoom * 0.01

		@lightManager.update(this)
		@io.postUpdate()

		if @player.health <= 0
			@start()

	render: =>
		@renderer.render(@scene, @camera)
