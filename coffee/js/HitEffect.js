// Generated by CoffeeScript 1.7.1
(function() {
  var DRAG, FADE, GRAVITY, LIFESPAN, LIGHT_COLOR, LIGHT_INTENSITY, LIGHT_LIFESPAN, LIGHT_RADIUS, PARTICLE_COUNT,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  LIGHT_RADIUS = 4;

  LIGHT_INTENSITY = 0.10;

  LIGHT_COLOR = 0xFFFFFF;

  PARTICLE_COUNT = 8;

  GRAVITY = 9.8 / 60.;

  DRAG = 0.99;

  FADE = 0.01;

  LIFESPAN = 15;

  LIGHT_LIFESPAN = 6;

  window.HitEffect = (function() {
    function HitEffect(x, y, z, type) {
      var i, positions, texture, velocities;
      this.x = x;
      this.y = y;
      this.z = z;
      if (type == null) {
        type = "concrete";
      }
      this.dispose = __bind(this.dispose, this);
      this.update = __bind(this.update, this);
      this.init = __bind(this.init, this);
      this.lifespan = LIFESPAN;
      this.geom = new THREE.BufferGeometry();
      this.geom.dynamic = true;
      this.geom.attributes = {
        position: {
          itemSize: 3,
          array: new Float32Array(PARTICLE_COUNT * 3),
          numItems: PARTICLE_COUNT * 3
        },
        velocity: {
          itemSize: 3,
          array: new Float32Array(PARTICLE_COUNT * 3),
          numItems: PARTICLE_COUNT * 3
        }
      };
      positions = this.geom.attributes.position.array;
      velocities = this.geom.attributes.velocity.array;
      i = 0;
      while (i < PARTICLE_COUNT * 3) {
        positions[i] = Random.normal(0.05);
        positions[i + 1] = Random.normal(0.05);
        positions[i + 2] = Random.normal(0.05);
        velocities[i] = positions[i] * 140;
        velocities[i + 1] = positions[i + 1] * 140;
        velocities[i + 2] = positions[i + 2] * 35;
        i += 3;
      }
      this.geom.computeBoundingSphere();
      texture = null;
      if (type === "metal") {
        texture = THREE.ImageUtils.loadTexture("resources/images/metal_hit.png");
      } else if (type === "flesh") {
        texture = THREE.ImageUtils.loadTexture("resources/images/flesh_hit.png");
      } else if (type === "concrete") {
        texture = THREE.ImageUtils.loadTexture("resources/images/concrete_hit.png");
      } else if (type === "wood") {
        texture = THREE.ImageUtils.loadTexture("resources/images/wood_hit.png");
      } else {
        texture = THREE.ImageUtils.loadTexture("resources/images/generic_hit.png");
      }
      this.material = new THREE.ParticleSystemMaterial({
        size: 0.3,
        map: texture,
        blending: THREE.AdditiveBlending,
        transparent: true
      });
      this.material.depthWrite = false;
      this.particles = new THREE.ParticleSystem(this.geom, this.material);
      this.particles.sortParticles = true;
      this.particles.position.set(this.x, this.y, this.z);
    }

    HitEffect.prototype.init = function(game) {
      game.scene.add(this.particles);
      this.light = game.lightManager.getPointLight(this.x, this.y, this.z);
      this.light.intensity = LIGHT_INTENSITY;
      this.light.color = LIGHT_COLOR;
      this.light.distance = LIGHT_RADIUS;
      return this.light.update();
    };

    HitEffect.prototype.update = function(game) {
      var i, positions, velocities;
      positions = this.geom.attributes.position.array;
      velocities = this.geom.attributes.velocity.array;
      i = 0;
      while (i < PARTICLE_COUNT * 3) {
        positions[i] += velocities[i] / 60;
        positions[i + 1] += velocities[i + 1] / 60;
        positions[i + 2] += velocities[i + 2] / 60;
        velocities[i] *= DRAG;
        velocities[i + 1] *= DRAG;
        velocities[i + 2] *= DRAG;
        velocities[i + 2] -= GRAVITY;
        i += 3;
      }
      this.geom.attributes.position.needsUpdate = true;
      this.geom.attributes.velocity.needsUpdate = true;
      this.geom.computeBoundingSphere();
      this.material.opacity = this.lifespan / LIFESPAN;
      this.light.intensity = Math.max(LIGHT_INTENSITY * (this.lifespan - (LIFESPAN - LIGHT_LIFESPAN)) / LIGHT_LIFESPAN, 0.0);
      this.light.update();
      this.lifespan--;
      if (this.lifespan <= 0) {
        return game.removeEntity(this);
      }
    };

    HitEffect.prototype.dispose = function(game) {
      if (this.disposed) {
        console.log("removing HitEffect twice");
      }
      this.disposed = true;
      game.scene.remove(this.particles);
      return this.light.dispose();
    };

    return HitEffect;

  })();

}).call(this);

//# sourceMappingURL=HitEffect.map
