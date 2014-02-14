// Generated by CoffeeScript 1.7.1
(function() {
  var SIZE, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2PolygonShape, b2Vec2,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  SIZE = 1.0;

  window.Box = (function() {
    Box.SIZE = SIZE;

    Box.prototype.hitEffectType = "wood";

    function Box(x, y) {
      this.dispose = __bind(this.dispose, this);
      this.hit = __bind(this.hit, this);
      var bump, material, texture;
      texture = new THREE.ImageUtils.loadTexture("resources/images/crate1_diffuse.png");
      bump = new THREE.ImageUtils.loadTexture("resources/images/crate1_bump.png");
      material = new THREE.MeshPhongMaterial({
        map: texture,
        bumpMap: bump,
        bumpScale: 0.02
      });
      this.mesh = new THREE.Mesh(new THREE.CubeGeometry(SIZE, SIZE, SIZE), material);
      this.mesh.position.set(x, y, SIZE / 2);
      this.mesh.castShadow = true;
      this.mesh.recieveShadow = true;
      this.health = 200;
    }

    Box.prototype.init = function(game) {
      var bodyDef, fixDef;
      game.scene.add(this.mesh);
      fixDef = new b2FixtureDef();
      fixDef.density = 2.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.02;
      fixDef.shape = new b2PolygonShape();
      fixDef.shape.SetAsBox(SIZE / 2, SIZE / 2);
      bodyDef = new b2BodyDef();
      bodyDef.type = b2Body.b2_dynamicBody;
      this.body = game.world.CreateBody(bodyDef);
      this.body.SetUserData(this);
      this.body.SetPosition(new b2Vec2(this.mesh.position.x, this.mesh.position.y));
      this.body.CreateFixture(fixDef);
      this.body.SetLinearDamping(10.0);
      return this.body.SetAngularDamping(30.0);
    };

    Box.prototype.update = function(game) {
      var p;
      p = this.body.GetWorldCenter();
      this.mesh.position.x = p.x;
      this.mesh.position.y = p.y;
      return this.mesh.rotation.z = this.body.GetAngle();
    };

    Box.prototype.hit = function(game, other) {
      var effect, p;
      if (other.isBullet) {
        p = this.body.GetWorldCenter();
        this.health -= other.damage;
        if (this.health <= 0 && !this.alreadyRemoved) {
          game.removeEntity(this);
          effect = new BoxBrokenEffect(p.x, p.y, this.body.GetAngle());
          return game.addEntity(effect);
        }
      }
    };

    Box.prototype.dispose = function(game) {
      game.world.DestroyBody(this.body);
      return game.scene.remove(this.mesh);
    };

    return Box;

  })();

}).call(this);

//# sourceMappingURL=Box.map
