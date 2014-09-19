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
SPEED = 0.25

class window.Bullet
    isBullet: true

    constructor: (@x, @y, @z, @dx, @dy, @vx, @vy, @damage) ->

    init: (game) ->
        # Graphics
        @mesh = new THREE.Mesh(new THREE.SphereGeometry(RADIUS * 1.0, 16, 16),
                new THREE.MeshBasicMaterial({color: 0xFFAA00}))
        @mesh.visible = false
        @mesh.position.set(@x, @y, @z)
        game.scene.add(@mesh)

        @effect = new BulletEffect(this, @x, @y, @z)
        game.addEntity(@effect)

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
        p = @body.GetWorldCenter()
        @x = p.x
        @y = p.y
        v = @body.GetLinearVelocity();
        @vx = v.x
        @vy = v.y
        @mesh.position.x = @x
        @mesh.position.y = @y
        @effect.setEnd(@x, @y)
        @lifespan -= 1 / 60.0
        if @lifespan <= 0
            game.removeEntity(this)

    getDamage: (armor) ->
        return Random.normal(@damage / 10, @damage)

    hit: (game, other) =>
        if other != null && !@alreadyRemoved
            p = @body.GetWorldCenter()
            @effect.setEnd(p.x, p.y)
            hitEffectType = null
            if other && other.hitEffectType
                hitEffectType = other.hitEffectType
            effect = new HitEffect(p.x, p.y, @z, @vx, @vy, hitEffectType)
            game.addEntity(effect)
            game.removeEntity(this)
        return true

    dispose: (game) =>
        game.scene.remove(@mesh)
        game.world.DestroyBody(@body)
        @effect.lifespan = 1


class BulletEffect
    constructor: (@bullet, x, y, z)->
        @lifespan = -1
        @shouldRemove = false
        @geometry = new THREE.Geometry()
        @geometry.vertices.push(new THREE.Vector3(x, y, z));
        @geometry.vertices.push(new THREE.Vector3(x, y, z));
        material = new THREE.LineBasicMaterial {
            color: 0xFFFF00,
            blending: THREE.AdditiveBlending,
            transparent: true,
            opacity: 0.1
        }
        @line = new THREE.Line(@geometry, material)

    init: (game) ->
        game.scene.add(@line)

    preUpdate: (game) ->
        if @lifespan >= 0
            @lifespan--
            if @lifespan <= 0
                game.removeEntity(this)

    setEnd: (x, y) ->
        @geometry.vertices[0].x = @geometry.vertices[1].x
        @geometry.vertices[0].y = @geometry.vertices[1].y
        @geometry.vertices[0].z = @geometry.vertices[1].z
        @geometry.vertices[1].x = x
        @geometry.vertices[1].y = y
        @geometry.verticesNeedUpdate = true;

    dispose: (game) =>
        game.scene.remove(@line)