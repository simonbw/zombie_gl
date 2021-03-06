// Generated by CoffeeScript 1.8.0
(function() {
  var FLASHLIGHT_COLOR, FLASHLIGHT_DISTANCE, FLASHLIGHT_INTENSITY, HEIGHT, RADIUS, SPEED, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2PolygonShape, b2Vec2,
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

  SPEED = 0.5;

  FLASHLIGHT_INTENSITY = 0.65;

  FLASHLIGHT_DISTANCE = 32;

  FLASHLIGHT_COLOR = 0xFFEEBB;

  window.Player = (function() {
    function Player(x, y) {
      this.x = x;
      this.y = y;
      this.hit = __bind(this.hit, this);
      this.health = 100;
      this.facingDirection = 0;
      this.guns = [new guns['M4'](), new guns['FiveSeven']()];
      this.gun = this.guns[0];
      this.mesh = new THREE.Mesh(new THREE.CylinderGeometry(RADIUS, RADIUS, HEIGHT, 40, 1), new THREE.MeshLambertMaterial({
        color: 0x00DD00
      }));
      this.mesh.position.z = HEIGHT / 2;
      this.mesh.rotation.x = Math.PI / 2;
      this.flashlight = new THREE.SpotLight(FLASHLIGHT_COLOR, FLASHLIGHT_INTENSITY, FLASHLIGHT_DISTANCE);
      this.flashlight.castShadow = true;
      this.flashlight.shadowMapSoft = true;
      this.flashlight.shadowMapWidth = 2048;
      this.flashlight.shadowMapHeight = 2048;
      this.flashlight.shadowCameraNear = 0.1;
      this.flashlight.shadowCameraFar = 100000;
      this.flashlight.shadowCameraFov = 60;
    }

    Player.prototype.init = function(game) {
      var bodyDef, fixDef;
      game.scene.add(this.mesh);
      game.scene.add(this.flashlight);
      fixDef = new b2FixtureDef();
      fixDef.density = 1.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.0;
      fixDef.shape = new b2CircleShape(RADIUS * 0.98);
      bodyDef = new b2BodyDef();
      bodyDef.type = b2Body.b2_dynamicBody;
      this.body = game.world.CreateBody(bodyDef);
      this.body.SetPosition(new b2Vec2(this.x, this.y));
      this.body.SetUserData(this);
      this.body.CreateFixture(fixDef);
      this.body.SetLinearDamping(10.0);
      return this.body.SetAngularDamping(128.0);
    };

    Player.prototype.nextGun = function() {
      return this.gun = this.guns[(this.guns.indexOf(this.gun) + 1) % this.guns.length];
    };

    Player.prototype.rotate = function(angle) {
      var currentAngle, diff, limit, torque;
      limit = 0.3;
      currentAngle = this.body.GetAngle();
      diff = Math.mod(angle - currentAngle + Math.PI, Math.PI * 2) - Math.PI;
      diff = diff * Math.abs(diff);
      torque = Math.min(limit, Math.max(diff, -limit));
      torque *= 512;
      return this.body.ApplyTorque(torque);
    };

    Player.prototype.preUpdate = function(game) {
      return this.rotate(game.io.lookDirection);
    };

    Player.prototype.update = function(game) {
      var aimDistance, aimHeight, dx, dy, impulse, p, v;
      this.facingDirection = this.body.GetAngle();
      p = this.body.GetWorldCenter();
      this.x = p.x;
      this.y = p.y;
      dx = Math.cos(this.facingDirection);
      dy = Math.sin(this.facingDirection);
      v = this.body.GetLinearVelocity();
      aimHeight = 0;
      aimDistance = 200;
      if (game.io.nextGunPressed) {
        this.nextGun();
      }
      this.gun.update(game);
      if (game.io.trigger) {
        this.body.ApplyTorque(this.gun.pullTrigger(game, game.io.triggerPressed, p.x + RADIUS * dx, p.y + RADIUS * dy, HEIGHT * 0.6, dx, dy, v.x / 60.0, v.y / 60.0));
      }
      if (game.io.reloadPressed) {
        this.gun.reload(game);
      }
      impulse = new b2Vec2(SPEED * game.io.moveX, SPEED * game.io.moveY);
      this.body.ApplyImpulse(impulse, this.body.GetWorldCenter());
      this.mesh.rotation.y = this.facingDirection;
      this.mesh.position.x = p.x;
      this.mesh.position.y = p.y;
      this.flashlight.visible = game.io.flashlight;
      this.flashlight.castShadow = false && game.io.flashlight;
      this.flashlight.position.set(p.x + dx * RADIUS, p.y + dy * RADIUS, HEIGHT * 0.6);
      return this.flashlight.target.position.set(p.x + aimDistance * dx, p.y + aimDistance * dy, aimHeight);
    };

    Player.prototype.hit = function(game, other) {
      if (other.isZombie) {
        return this.health -= 3;
      }
    };

    return Player;

  })();

}).call(this);

//# sourceMappingURL=Player.js.map
