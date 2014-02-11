// Generated by CoffeeScript 1.7.1
(function() {
  var HEIGHT, LIGHT_COLOR, LIGHT_INTENSITY, LIGHT_RADIUS, SIZE, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2PolygonShape, b2Vec2;

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  SIZE = 0.2;

  HEIGHT = 5.0;

  LIGHT_COLOR = 0xFFEECC;

  LIGHT_RADIUS = 128;

  LIGHT_INTENSITY = 0.8;

  window.StreetLight = (function() {
    function StreetLight(x, y) {
      this.x = x;
      this.y = y;
      this.mesh = new THREE.Mesh(new THREE.CubeGeometry(SIZE, SIZE, HEIGHT), new THREE.MeshPhongMaterial({
        color: 0x222222
      }));
      this.mesh.position.set(x, y, HEIGHT / 2);
    }

    StreetLight.prototype.init = function(game) {
      var bodyDef, fixDef;
      game.scene.add(this.mesh);
      this.light = game.lightManager.getPointLight(this.x, this.y, HEIGHT, LIGHT_INTENSITY, LIGHT_RADIUS, LIGHT_COLOR);
      fixDef = new b2FixtureDef();
      fixDef.density = 1.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.02;
      fixDef.shape = new b2PolygonShape();
      fixDef.shape.SetAsBox(SIZE / 2, SIZE / 2);
      bodyDef = new b2BodyDef();
      bodyDef.type = b2Body.b2_staticBody;
      this.body = game.world.CreateBody(bodyDef);
      this.body.SetUserData(this);
      this.body.SetPosition(new b2Vec2(this.mesh.position.x, this.mesh.position.y));
      return this.body.CreateFixture(fixDef);
    };

    return StreetLight;

  })();

}).call(this);

//# sourceMappingURL=StreetLight.map
