// Generated by CoffeeScript 1.7.1
(function() {
  var RADIUS, SPEED, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2PolygonShape, b2Vec2,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  RADIUS = 0.05;

  SPEED = 0.5;

  window.Bullet = (function() {
    Bullet.prototype.isBullet = true;

    function Bullet(x, y, z, dx, dy, vx, vy) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.dx = dx;
      this.dy = dy;
      this.vx = vx;
      this.vy = vy;
      this.dispose = __bind(this.dispose, this);
      this.hit = __bind(this.hit, this);
    }

    Bullet.prototype.init = function(game) {
      var bodyDef, fixDef, s;
      this.mesh = new THREE.Mesh(new THREE.SphereGeometry(RADIUS * 1.0, 16, 16), new THREE.MeshBasicMaterial({
        color: 0xFFAA00
      }));
      this.mesh.visible = false;
      game.scene.add(this.mesh);
      this.mesh.position.set(this.x, this.y, this.z);
      this.light = game.req;
      fixDef = new b2FixtureDef();
      fixDef.density = 0.1;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.0;
      fixDef.shape = new b2CircleShape(RADIUS * 0.9);
      bodyDef = new b2BodyDef();
      bodyDef.type = b2Body.b2_dynamicBody;
      bodyDef.bullet = true;
      this.body = game.world.CreateBody(bodyDef);
      this.body.SetUserData(this);
      this.body.CreateFixture(fixDef);
      this.body.SetPosition(new b2Vec2(this.x, this.y));
      this.body.SetLinearVelocity(new b2Vec2(this.vx, this.vy));
      s = Random.normal(SPEED / 10, SPEED);
      this.body.ApplyImpulse(new b2Vec2(this.dx * s, this.dy * s), this.body.GetWorldCenter());
      return this.lifespan = 2.0;
    };

    Bullet.prototype.update = function(game) {
      var p, v;
      this.facingDirection = game.io.lookDirection;
      p = this.body.GetWorldCenter();
      v = this.body.GetLinearVelocity();
      this.mesh.position.x = p.x;
      this.mesh.position.y = p.y;
      this.lifespan -= 1 / 60.0;
      if (this.lifespan <= 0) {
        return game.removeEntity(this);
      }
    };

    Bullet.prototype.hit = function(game, other) {
      var effect, hitEffectType, p;
      if (other !== null && !this.alreadyRemoved) {
        p = this.body.GetWorldCenter();
        hitEffectType = null;
        if (other && other.hitEffectType) {
          hitEffectType = other.hitEffectType;
        }
        effect = new HitEffect(p.x, p.y, this.z, hitEffectType);
        game.addEntity(effect);
        game.removeEntity(this);
      }
      return true;
    };

    Bullet.prototype.dispose = function(game) {
      game.scene.remove(this.mesh);
      return game.world.DestroyBody(this.body);
    };

    return Bullet;

  })();

}).call(this);

//# sourceMappingURL=Bullet.map
