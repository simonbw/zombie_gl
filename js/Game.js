// Generated by CoffeeScript 1.7.1
(function() {
  var FRAMERATE, PHYSICS_STEPS, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2PolygonShape, b2Vec2, b2World,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  b2World = Box2D.Dynamics.b2World;

  FRAMERATE = 60.0;

  PHYSICS_STEPS = 3;

  window.Game = (function() {
    function Game() {
      this.render = __bind(this.render, this);
      this.update = __bind(this.update, this);
      this.removalPass = __bind(this.removalPass, this);
      this.removeEntity = __bind(this.removeEntity, this);
      this.addEntity = __bind(this.addEntity, this);
      this.start = __bind(this.start, this);
      this.io = new IO(this);
      Box2D.Common.b2Settings.b2_maxTranslation = 5.0;
      this.stats = new Stats();
      this.renderer = new THREE.WebGLRenderer({
        antialias: true
      });
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      window.document.body.appendChild(this.renderer.domElement);
      window.addEventListener('resize', (function(_this) {
        return function() {
          _this.renderer.setSize(window.innerWidth, window.innerHeight);
          _this.camera.aspect = window.innerWidth / window.innerHeight;
          return _this.camera.updateProjectionMatrix();
        };
      })(this));
      this.lightManager = new LightManager(this);
      this.soundManager = new SoundManager(this);
    }

    Game.prototype.initWorld = function() {
      var body, listener, _i, _len, _ref;
      if (this.world) {
        _ref = this.world.GetBodyList();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          body = _ref[_i];
          this.world.DestroyBody(body);
        }
      }
      this.world = new b2World(new b2Vec2(0, 0), true);
      listener = new Box2D.Dynamics.b2ContactListener();
      listener.BeginContact = (function(_this) {
        return function(contact) {
          var a, b, hit;
          a = contact.GetFixtureA().GetBody().GetUserData();
          b = contact.GetFixtureB().GetBody().GetUserData();
          hit = false;
          if (a && a.hit) {
            hit = a.hit(_this, b);
          }
          if (b && b.hit) {
            return hit = b.hit(_this, a) || hit;
          }
        };
      })(this);
      listener.PostSolve = (function(_this) {
        return function(contact, impulse) {
          var a, b;
          a = contact.GetFixtureA().GetBody().GetUserData();
          b = contact.GetFixtureB().GetBody().GetUserData();
          if (a && a.hit2) {
            a.hit2(_this, b, impulse);
          }
          if (b && b.hit2) {
            return b.hit2(_this, a, impulse);
          }
        };
      })(this);
      return this.world.SetContactListener(listener);
    };

    Game.prototype.initScene = function() {
      this.scene = new THREE.Scene();
      this.camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 20000);
      this.scene.add(this.camera);
      this.camera.position.set(0, 0, 20);
      this.camera.lookAt({
        x: 0,
        y: 0,
        z: 0
      });
      return this.lightManager.reset(this);
    };

    Game.prototype.start = function() {
      var i, _i;
      if (this.request) {
        window.cancelAnimationFrame(this.request);
      }
      this.stats.newGame();
      this.updateList = [];
      this.updateList2 = [];
      this.toRemove = [];
      this.initWorld();
      this.initScene();
      this.player = this.addEntity(new Player(0, 1));
      this.addEntity(new Ground(0, 0));
      this.addEntity(new StreetLight(0, 0));
      this.addEntity(new StreetLight(0, -17.5));
      this.addEntity(new StreetLight(0, 17.5));
      this.addEntity(new Building(10, -25));
      this.addEntity(new Building(10, -10));
      this.addEntity(new Building(10, 0));
      this.addEntity(new Building(10, 10));
      this.addEntity(new Building(10, 25));
      this.addEntity(new Building(5, -40));
      this.addEntity(new Building(15, -40));
      this.addEntity(new Building(25, -30));
      this.addEntity(new Building(25, -20));
      this.addEntity(new Building(25, -10));
      this.addEntity(new Building(25, 0));
      this.addEntity(new Building(25, 10));
      this.addEntity(new Building(25, 20));
      this.addEntity(new Building(25, 30));
      this.addEntity(new Building(15, 40));
      this.addEntity(new Building(5, 40));
      this.addEntity(new Building(-10, -25));
      this.addEntity(new Building(-10, -10));
      this.addEntity(new Building(-10, 0));
      this.addEntity(new Building(-10, 10));
      this.addEntity(new Building(-10, 25));
      this.addEntity(new Building(-5, -40));
      this.addEntity(new Building(-15, -40));
      this.addEntity(new Building(-25, -30));
      this.addEntity(new Building(-25, -20));
      this.addEntity(new Building(-25, -10));
      this.addEntity(new Building(-25, 0));
      this.addEntity(new Building(-25, 10));
      this.addEntity(new Building(-25, 20));
      this.addEntity(new Building(-25, 30));
      this.addEntity(new Building(-15, 40));
      this.addEntity(new Building(-5, 40));
      this.addEntity(new ZombieSpawner(17.5, 32.5, 0.1));
      this.addEntity(new ZombieSpawner(17.5, -32.5, 0.1));
      this.addEntity(new ZombieSpawner(-17.5, 32.5, 0.1));
      this.addEntity(new ZombieSpawner(-17.5, -32.5, 0.1));
      for (i = _i = 1; _i < 11; i = ++_i) {
        this.addEntity(new Box(2, i * 3));
        this.addEntity(new Box(-2, i * 3));
        this.addEntity(new Box(2, -i * 3));
        this.addEntity(new Box(-2, -i * 3));
        this.addEntity(new Box(17.5, i * 3));
        this.addEntity(new Box(-17.5, i * 3));
        this.addEntity(new Box(17.5, -i * 3));
        this.addEntity(new Box(-17.5, -i * 3));
      }
      return this.update();
    };

    Game.prototype.addEntity = function(entity) {
      if (entity.init) {
        entity.init(this);
      }
      if (entity.update) {
        this.updateList.push(entity);
      }
      if (entity.update2) {
        this.updateList2.push(entity);
      }
      return entity;
    };

    Game.prototype.removeEntity = function(entity) {
      if (!entity.alreadyRemoved && (entity.update || entity.update2 || entity.dispose)) {
        entity.alreadyRemoved = true;
        this.toRemove.push(entity);
      }
      return entity;
    };

    Game.prototype.removalPass = function() {
      var entity, _i, _len, _ref;
      _ref = this.toRemove;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        if (entity.update) {
          this.updateList.splice(this.updateList.indexOf(entity), 1);
        }
        if (entity.update2) {
          this.updateList2.splice(this.updateList.indexOf(entity), 1);
        }
        if (entity.dispose) {
          entity.dispose(this);
        }
      }
      return this.toRemove = [];
    };

    Game.prototype.update = function() {
      var entity, i, n, _i, _j, _len, _len1, _ref, _ref1;
      this.request = window.requestAnimationFrame(this.update);
      this.render();
      this.io.update();
      if (this.io.moveX !== 0) {
        n = 100;
      }
      i = 0;
      while (i < PHYSICS_STEPS) {
        i++;
        this.world.Step(1 / (FRAMERATE * PHYSICS_STEPS), 3, 3);
        this.removalPass();
      }
      _ref = this.updateList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        entity.update(this);
      }
      this.removalPass();
      _ref1 = this.updateList2;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        entity = _ref1[_j];
        entity.update2(this);
      }
      this.removalPass();
      this.camera.position.x = 0.9 * this.camera.position.x + 0.1 * this.player.mesh.position.x;
      this.camera.position.y = 0.9 * this.camera.position.y + 0.1 * this.player.mesh.position.y;
      this.camera.position.z += -this.camera.position.z * this.io.zoom * 0.01;
      this.lightManager.update(this);
      this.io.update2();
      if (this.player.health <= 0) {
        return this.start();
      }
    };

    Game.prototype.render = function() {
      return this.renderer.render(this.scene, this.camera);
    };

    return Game;

  })();

}).call(this);

//# sourceMappingURL=Game.map
