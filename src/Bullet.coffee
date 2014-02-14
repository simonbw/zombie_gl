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
RADIUS = 0.05
SPEED = 0.5

class window.Bullet
	isBullet: true

	constructor: (@x, @y, @z, @dx, @dy, @vx, @vy, @damage) ->

	init: (game) ->
		# Graphics
		@mesh = new THREE.Mesh(new THREE.SphereGeometry(RADIUS * 1.0, 16, 16), new THREE.MeshBasicMaterial({color:0xFFAA00}))
		@mesh.visible = false
		game.scene.add(@mesh)
		@mesh.position.set(@x, @y, @z)

		@light = game.req

		# Physics
		fixDef = new b2FixtureDef()
		fixDef.density = 0.1
		fixDef.friction = 0.5
		fixDef.restitution = 0.0
		fixDef.shape = new b2CircleShape(RADIUS * 0.9)
		bodyDef = new b2BodyDef()
		bodyDef.type = b2Body.b2_dynamicBody
		bodyDef.bullet = true

		@body = game.world.CreateBody(bodyDef)
		@body.SetUserData(this)
		@body.CreateFixture(fixDef)
		@body.SetPosition(new b2Vec2(@x, @y))
		@body.SetLinearVelocity(new b2Vec2(@vx, @vy))
		s = Random.normal(SPEED / 10, SPEED)
		@body.ApplyImpulse(new b2Vec2(@dx * s, @dy * s), @body.GetWorldCenter())
		@lifespan = 2.0

	update: (game)->
		@facingDirection = game.io.lookDirection
		p = @body.GetWorldCenter()
		v = @body.GetLinearVelocity()
		@mesh.position.x = p.x
		@mesh.position.y = p.y
		@lifespan -= 1 / 60.0
		if @lifespan <= 0
			game.removeEntity(this)
	
	hit: (game, other) =>
		if other != null && !@alreadyRemoved
			p = @body.GetWorldCenter()
			hitEffectType = null
			if other && other.hitEffectType
				hitEffectType = other.hitEffectType
			effect = new HitEffect(p.x, p.y, @z, hitEffectType)
			game.addEntity(effect)
			game.removeEntity(this)
		return true

	dispose: (game) =>
		game.scene.remove(@mesh)
		game.world.DestroyBody(@body)
