# Imports
b2Vec2 = Box2D.Common.Math.b2Vec2;
b2BodyDef = Box2D.Dynamics.b2BodyDef;
b2Body = Box2D.Dynamics.b2Body;
b2FixtureDef = Box2D.Dynamics.b2FixtureDef;
b2Fixture = Box2D.Dynamics.b2Fixture;
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;
b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

# Constants
RADIUS = 0.3
HEIGHT = 2.0
SPEED = 0.25

class window.Zombie

	isZombie: true
	
	hitEffectType: "flesh"

	constructor: (@x, @y) ->
		@facingDirection = 0
		@health = 100
		@mesh = new THREE.Mesh(new THREE.CylinderGeometry(RADIUS, RADIUS, HEIGHT, 40, 1), new THREE.MeshLambertMaterial({color: 0xDD0000}))
		@mesh.position.set(@x, @y, HEIGHT / 2)
		@mesh.rotation.x = Math.PI / 2
		@target = null

	init: (game) ->
		# Graphics
		game.scene.add(@mesh)

		# Physics
		fixDef = new b2FixtureDef()
		fixDef.density = 1.0
		fixDef.friction = 0.5
		fixDef.restitution = 0.0
		fixDef.shape = new b2CircleShape(RADIUS * 0.98)
		bodyDef = new b2BodyDef()
		bodyDef.type = b2Body.b2_dynamicBody

		@body = game.world.CreateBody(bodyDef)
		@body.SetUserData(this)
		@body.CreateFixture(fixDef)
		@body.SetLinearDamping(10.0)
		@body.SetPosition(new b2Vec2(@x, @y))

	update: (game)->
		p = @body.GetWorldCenter()
		@x = p.x
		@y = p.y
		
		player = game.player.body.GetWorldCenter()

		if Math.pow(player.x - p.x, 2) > -1
			@target = game.player.body.GetWorldCenter()

		@facingDirection = Math.atan2(@target.y - p.y, @target.x - p.x)
		dx = Math.cos(@facingDirection)
		dy = Math.sin(@facingDirection)
		v = @body.GetLinearVelocity()

		# Physics
		impulse = new b2Vec2(SPEED * dx, SPEED * dy)
		@body.ApplyImpulse(impulse, @body.GetWorldCenter())
		@body.SetAngle(@facingDirection)
		
		# Update graphics
		@mesh.position.x = p.x
		@mesh.position.y = p.y

	hit: (game, other) =>
		if other.isBullet
			p = @body.GetWorldCenter()
			@health -= other.damage
			if @health <= 0 && !@alreadyRemoved
				game.removeEntity(this)
				game.stats.addKill()

	dispose: (game) =>
		game.world.DestroyBody(@body)
		game.scene.remove(@mesh)