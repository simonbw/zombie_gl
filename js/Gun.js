// Generated by CoffeeScript 1.7.1
(function() {
  window.Gun = (function() {
    function Gun(soundName, fullauto, firerate, clipSize, reloadTime, damage, accuracy, recoil) {
      this.soundName = soundName;
      this.fullauto = fullauto;
      this.firerate = firerate;
      this.clipSize = clipSize;
      this.reloadTime = reloadTime;
      this.damage = damage;
      this.accuracy = accuracy;
      this.recoil = recoil;
      this.cooldown = 0;
      this.ammo = this.clipSize;
      this.reloading = false;
      this.reloadTime2 = 0.22;
      this.reloadSound = "" + this.soundName + "_reload";
      this.reloadFinishSound = "" + this.soundName + "_reload_finish";
      this.emptySound = "gun_empty";
    }

    Gun.prototype.update = function(game) {
      if (this.cooldown > 0) {
        this.cooldown -= 1 / 60;
      }
      if (this.reloading) {
        if (this.cooldown <= 0) {
          return this.reloadFinish(game);
        }
      }
    };

    Gun.prototype.reload = function(game) {
      if (!this.reloading && this.cooldown <= 1.0 && this.ammo < this.clipSize) {
        this.reloading = true;
        this.cooldown = this.reloadTime;
        return game.soundManager.playSound(this.reloadSound);
      }
    };

    Gun.prototype.reloadFinish = function(game) {
      this.reloading = false;
      this.ammo = this.clipSize;
      this.cooldown = this.reloadTime2;
      return game.soundManager.playSound(this.reloadFinishSound);
    };

    Gun.prototype.pullTrigger = function(game, firstPress, x, y, z, dx, dy, vx, vy) {
      var bullet, direction, flash;
      if (firstPress || this.fullauto) {
        if (this.cooldown <= 0 && this.ammo > 0) {
          this.ammo -= 1;
          this.cooldown += 60.0 / this.firerate;
          game.soundManager.playSound("" + this.soundName + "_shot");
          flash = new MuzzleFlash(x, y, z, dx, dy, vx, vy);
          game.addEntity(flash);
          direction = Math.atan2(dy, dx) + Random.normal(0.1 / this.accuracy);
          dx = Math.cos(direction);
          dy = Math.sin(direction);
          bullet = new Bullet(x + dx * 0.051, y + dy * 0.051, z, dx, dy, vx, vy, this.damage);
          game.addEntity(bullet);
          return Random.normal(this.recoil);
        } else if (firstPress && this.ammo === 0) {
          game.soundManager.playSound(this.emptySound);
        }
      }
      return 0;
    };

    return Gun;

  })();

}).call(this);

//# sourceMappingURL=Gun.map
