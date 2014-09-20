// Generated by CoffeeScript 1.8.0
(function() {
  var UNLOAD_DISTANCE;

  UNLOAD_DISTANCE = 5;

  window.SectorManager = (function() {
    function SectorManager(game) {
      this.game = game;
      this.sectors = {};
      this.postUpdate(this.game);
    }

    SectorManager.prototype.postUpdate = function(game) {
      var centerX, centerY;
      centerX = Math.floor(game.player.x / Sector.SIZE);
      centerY = Math.floor(game.player.y / Sector.SIZE);
      this.loadNear(game, centerX, centerY);
      return this.unloadFar(game, centerX, centerY);
    };

    SectorManager.prototype.loadNear = function(game, centerX, centerY) {
      var i, x2, y2, _i, _results;
      _results = [];
      for (i = _i = 0; _i <= 9; i = ++_i) {
        x2 = centerX - 1 + i % 3;
        y2 = centerY - 1 + Math.floor(i / 3);
        _results.push(this.loadSector(x2, y2));
      }
      return _results;
    };

    SectorManager.prototype.unloadFar = function(game, centerX, centerY) {
      var sector, x3, xy, y3, _ref, _ref1, _results;
      _ref = this.sectors;
      _results = [];
      for (xy in _ref) {
        sector = _ref[xy];
        _ref1 = xy.split(','), x3 = _ref1[0], y3 = _ref1[1];
        if (sector.loaded && Math.abs(x3 - centerX) + Math.abs(y3 - centerY) > UNLOAD_DISTANCE) {
          _results.push(this.unloadSector(sector));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    SectorManager.prototype.makeKey = function(x, y) {
      return x + ',' + y;
    };

    SectorManager.prototype.hasSector = function(x, y) {
      return this.makeKey(x, y) in this.sectors;
    };

    SectorManager.prototype.getSector = function(x, y) {
      if (!this.hasSector(x, y)) {
        this.setSector(x, y, new Sector(x, y));
      }
      return this.sectors[this.makeKey(x, y)];
    };

    SectorManager.prototype.setSector = function(x, y, sector) {
      return this.sectors[this.makeKey(x, y)] = sector;
    };

    SectorManager.prototype.loadSector = function(x, y) {
      var sector;
      sector = this.getSector(x, y);
      if (!sector.loaded) {
        return sector.load(this.game);
      }
    };

    SectorManager.prototype.unloadSector = function(x, y) {
      return this.getSector(x, y).unload(this.game);
    };

    return SectorManager;

  })();

}).call(this);

//# sourceMappingURL=SectorManager.js.map
