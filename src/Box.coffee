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
SIZE = 1.0

class window.Box
	@SIZE = SIZE

	@texture = new THREE.ImageUtils.loadTexture("resources/images/crate1_diffuse.png")
	@texture.anistropy = 16
	
	@bumpMap = new THREE.ImageUtils.loadTexture("resources/images/crate1_bump.png")

	@material = new THREE.MeshPhongMaterial {
		# color: 0x77664B,
		map: @texture,
		bumpMap: @bumpMap,
		bumpScale: 0.022
	}

	hitEffectType: "wood"

	constructor: (x, y) ->
		@mesh = new THREE.Mesh(new THREE.CubeGeometry(SIZE, SIZE, SIZE), Box.material)
		@mesh.position.set(x, y, SIZE / 2)

		@mesh.castShadow = true
		@mesh.recieveShadow = true

		@health = 200

	init: (game) ->
		# Graphics
		game.scene.add(@mesh)

		# Physics
		fixDef = new b2FixtureDef()
		fixDef.density = 2.0
		fixDef.friction = 0.5
		fixDef.restitution = 0.02
		fixDef.shape = new b2PolygonShape()
		fixDef.shape.SetAsBox(SIZE / 2, SIZE / 2)
		bodyDef = new b2BodyDef()
		bodyDef.type = b2Body.b2_dynamicBody

		@body = game.world.CreateBody(bodyDef)
		@body.SetUserData(this)
		@body.SetPosition(new b2Vec2(@mesh.position.x, @mesh.position.y))
		@body.CreateFixture(fixDef)
		@body.SetLinearDamping(10.0)
		@body.SetAngularDamping(30.0)

	update: (game)->
		# Update graphics
		p = @body.GetWorldCenter()
		@mesh.position.x = p.x
		@mesh.position.y = p.y
		@mesh.rotation.z = @body.GetAngle()

	hit: (game, other) =>
		if other.isBullet
			p = @body.GetWorldCenter()
			@health -= other.getDamage()
			if @health <= 0 && !@alreadyRemoved
				game.removeEntity(this)
				effect = new BoxBrokenEffect(p.x, p.y, @body.GetAngle())
				game.addEntity(effect)

	dispose: (game) =>
		game.world.DestroyBody(@body)
		game.scene.remove(@mesh)