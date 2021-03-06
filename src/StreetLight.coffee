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
SIZE = 0.2
HEIGHT = 5.0
LIGHT_COLOR = 0xFFFFEE
LIGHT_RADIUS = 24
LIGHT_INTENSITY = 0.5

class window.StreetLight

    @material = new THREE.MeshPhongMaterial {
        color: 0x222222
    }

    hitEffectType: "metal"

    constructor: (@x, @y) ->

    init: (game) ->
        # Graphics
        # TODO: Should this geometry and material be shared?
        @mesh = new THREE.Mesh(new THREE.CylinderGeometry(SIZE, SIZE, HEIGHT, 12, 1),
                material)
        @mesh.rotation.x = Math.PI / 2
        @mesh.position.set(@x, @y, HEIGHT / 2)
        game.scene.add(@mesh)

        @light = game.lightManager.getPointLight(@x, @y, HEIGHT, LIGHT_INTENSITY, LIGHT_RADIUS, LIGHT_COLOR)

        # Physics
        fixDef = new b2FixtureDef()
        fixDef.density = 1.0
        fixDef.friction = 0.5
        fixDef.restitution = 0.02
        fixDef.shape = new b2CircleShape(SIZE)
        bodyDef = new b2BodyDef()
        bodyDef.type = b2Body.b2_staticBody

        @body = game.world.CreateBody(bodyDef)
        @body.SetUserData(this)
        @body.SetPosition(new b2Vec2(@mesh.position.x, @mesh.position.y))
        @body.CreateFixture(fixDef)