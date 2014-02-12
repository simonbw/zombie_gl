// Generated by CoffeeScript 1.7.1
(function() {
  var HEIGHT, RADIUS, SPEED, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2PolygonShape, b2Vec2,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  RADIUS = 0.3;

  HEIGHT = 2.0;

  SPEED = 0.25;

  window.Zombie = (function() {
    Zombie.prototype.isZombie = true;

    Zombie.prototype.hitEffectType = "flesh";

    function Zombie(x, y) {
      this.x = x;
      this.y = y;
      this.dispose = __bind(this.dispose, this);
      this.hit = __bind(this.hit, this);
      this.facingDirection = 0;
      this.health = 100;
      this.mesh = new THREE.Mesh(new THREE.CylinderGeometry(RADIUS, RADIUS, HEIGHT, 40, 1), new THREE.MeshLambertMaterial({
        color: 0xDD0000
      }));
      this.mesh.position.set(this.x, this.y, HEIGHT / 2);
      this.mesh.rotation.x = Math.PI / 2;
      this.target = null;
    }

    Zombie.prototype.init = function(game) {
      var bodyDef, fixDef;
      game.scene.add(this.mesh);
      fixDef = new b2FixtureDef();
      fixDef.density = 1.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.0;
      fixDef.shape = new b2CircleShape(RADIUS * 0.98);
      bodyDef = new b2BodyDef();
      bodyDef.type = b2Body.b2_dynamicBody;
      this.body = game.world.CreateBody(bodyDef);
      this.body.SetUserData(this);
      this.body.CreateFixture(fixDef);
      this.body.SetLinearDamping(10.0);
      return this.body.SetPosition(new b2Vec2(this.x, this.y));
    };

    Zombie.prototype.update = function(game) {
      var dx, dy, impulse, p, player, v;
      p = this.body.GetWorldCenter();
      this.x = p.x;
      this.y = p.y;
      player = game.player.body.GetWorldCenter();
      if (Math.pow(player.x - p.x, 2) > -1) {
        this.target = game.player.body.GetWorldCenter();
      }
      this.facingDirection = Math.atan2(this.target.y - p.y, this.target.x - p.x);
      dx = Math.cos(this.facingDirection);
      dy = Math.sin(this.facingDirection);
      v = this.body.GetLinearVelocity();
      impulse = new b2Vec2(SPEED * dx, SPEED * dy);
      this.body.ApplyImpulse(impulse, this.body.GetWorldCenter());
      this.body.SetAngle(this.facingDirection);
      this.mesh.position.x = p.x;
      return this.mesh.position.y = p.y;
    };

    Zombie.prototype.hit = function(game, other) {
      var p;
      if (other.isBullet) {
        p = this.body.GetWorldCenter();
        this.health -= 25;
        if (this.health <= 0 && !this.alreadyRemoved) {
          return game.removeEntity(this);
        }
      }
    };

    Zombie.prototype.dispose = function(game) {
      game.world.DestroyBody(this.body);
      return game.scene.remove(this.mesh);
    };

    return Zombie;

  })();

}).call(this);

//# sourceMappingURL=Zombie.map