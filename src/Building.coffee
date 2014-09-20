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
SIZE = 10.0
HEIGHT = 15.0

class window.Building

    @material = new THREE.MeshPhongMaterial {
        color: 0xDDDDDD
        specular: 0xDDDDDD
        shininess: 1
        shading: THREE.FlatShading
    }

    hitEffectType: "concrete"

    constructor: (@x, @y) ->

    init: (game) ->
        # Graphics
        height = Random.normal(2, HEIGHT)
        @mesh = new THREE.Mesh(new THREE.CubeGeometry(SIZE, SIZE, height), Building.material)
        @mesh.position.set(@x + SIZE / 2, @y + SIZE / 2, height / 2)
        # @mesh.castShadow = true
        # @mesh.receiveShadow = true
        game.scene.add(@mesh)

        # Physics
        fixDef = new b2FixtureDef()
        fixDef.density = 1.0
        fixDef.friction = 0.5
        fixDef.restitution = 0.02
        fixDef.shape = new b2PolygonShape()
        fixDef.shape.SetAsBox(SIZE / 2, SIZE / 2)
        bodyDef = new b2BodyDef()
        bodyDef.type = b2Body.b2_staticBody

        @body = game.world.CreateBody(bodyDef)
        @body.SetUserData(this)
        @body.SetPosition(new b2Vec2(@mesh.position.x, @mesh.position.y))
        @body.CreateFixture(fixDef)
