# Imports
b2Vec2 = Box2D.Common.Math.b2Vec2
b2BodyDef = Box2D.Dynamics.b2BodyDef
b2Body = Box2D.Dynamics.b2Body
b2FixtureDef = Box2D.Dynamics.b2FixtureDef
b2Fixture = Box2D.Dynamics.b2Fixture
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
b2DebugDraw = Box2D.Dynamics.b2DebugDraw

# Constants
RADIUS = 0.3
HEIGHT = 2.0
SPEED = 0.5
FLASHLIGHT_INTENSITY = 0.65
FLASHLIGHT_DISTANCE = 32
FLASHLIGHT_COLOR = 0xFFEEBB

class window.Player
    constructor: (@x, @y) ->
        @health = 100
        @facingDirection = 0
        @guns = [new guns['M4'](), new guns['FiveSeven']()]
        @gun = @guns[0]

        @mesh = new THREE.Mesh(new THREE.CylinderGeometry(RADIUS, RADIUS, HEIGHT, 40, 1),
                new THREE.MeshLambertMaterial({color: 0x00DD00}))
        # @mesh = new THREE.Mesh Models.models['player'].geometry, new THREE.MeshLambertMaterial {color: 0x776655}
        @mesh.position.z = HEIGHT / 2
        @mesh.rotation.x = Math.PI / 2

        @flashlight = new THREE.SpotLight(FLASHLIGHT_COLOR, FLASHLIGHT_INTENSITY, FLASHLIGHT_DISTANCE)
        @flashlight.castShadow = true
        @flashlight.shadowMapSoft = true
        @flashlight.shadowMapWidth = 2048
        @flashlight.shadowMapHeight = 2048
        @flashlight.shadowCameraNear = 0.1
        @flashlight.shadowCameraFar = 100000
        @flashlight.shadowCameraFov = 60

    init: (game) ->
        # Graphics
        game.scene.add(@mesh)
        game.scene.add(@flashlight)

        # Physics
        fixDef = new b2FixtureDef()
        fixDef.density = 1.0
        fixDef.friction = 0.5
        fixDef.restitution = 0.0
        fixDef.shape = new b2CircleShape(RADIUS * 0.98)
        bodyDef = new b2BodyDef()
        bodyDef.type = b2Body.b2_dynamicBody

        @body = game.world.CreateBody(bodyDef)
        @body.SetPosition(new b2Vec2(@x, @y))
        @body.SetUserData(this)
        @body.CreateFixture(fixDef)
        @body.SetLinearDamping(10.0)
        @body.SetAngularDamping(128.0)

    nextGun: ->
        @gun = @guns[(@guns.indexOf(@gun) + 1) % @guns.length]

    rotate: (angle) ->
        limit = 0.3
        currentAngle = @body.GetAngle()
        diff = Math.mod(angle - currentAngle + Math.PI, (Math.PI * 2)) - Math.PI
        diff = diff * Math.abs(diff)
        torque = Math.min(limit, Math.max(diff, -limit))
        torque *= 512
        @body.ApplyTorque(torque)

    preUpdate: (game) ->
        @rotate(game.io.lookDirection)

    update: (game)->
        @facingDirection = @body.GetAngle()
        p = @body.GetWorldCenter()
        @x = p.x
        @y = p.y
        dx = Math.cos(@facingDirection)
        dy = Math.sin(@facingDirection)
        v = @body.GetLinearVelocity()

        aimHeight = 0
        aimDistance = 200

        # Gun
        if game.io.nextGunPressed
            @nextGun()
        @gun.update(game)
        if game.io.trigger
            @body.ApplyTorque(@gun.pullTrigger(game, game.io.triggerPressed, p.x + RADIUS * dx, p.y + RADIUS * dy,
                            HEIGHT * 0.6, dx, dy, v.x / 60.0, v.y / 60.0))
        if game.io.reloadPressed
            @gun.reload(game)

        # Physics
        impulse = new b2Vec2(SPEED * game.io.moveX, SPEED * game.io.moveY)
        @body.ApplyImpulse(impulse, @body.GetWorldCenter())

        # Update graphics
        @mesh.rotation.y = @facingDirection
        @mesh.position.x = p.x
        @mesh.position.y = p.y

        @flashlight.visible = game.io.flashlight
        @flashlight.castShadow = false && game.io.flashlight

        @flashlight.position.set(p.x + dx * RADIUS, p.y + dy * RADIUS, HEIGHT * 0.6)
        @flashlight.target.position.set(p.x + aimDistance * dx, p.y + aimDistance * dy, aimHeight)

    hit: (game, other) =>
        if other.isZombie
            @health -= 3
