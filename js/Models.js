// Generated by CoffeeScript 1.7.1
(function() {
  var MODELS;

  MODELS = ["zombie", "player"];

  window.Models = (function() {
    function Models() {}

    Models.models = {};

    Models.init = function(callback) {
      this.callback = callback;
      return Models.next(null);
    };

    Models.next = function(geometry, materials) {
      var loader, name;
      if (geometry || materials) {
        name = MODELS.pop();
        console.log("loaded " + name);
        if (!materials) {
          materials = [new THREE.MeshLambertMaterial()];
        }
        Models.models[name] = {
          'geometry': geometry,
          'materials': materials
        };
      }
      if (MODELS.length > 0) {
        name = MODELS[MODELS.length - 1];
        console.log("loading " + name);
        loader = new THREE.JSONLoader();
        return loader.load("resources/models/" + name + ".js", Models.next);
      } else {
        return Models.callback();
      }
    };

    return Models;

  })();

}).call(this);

//# sourceMappingURL=Models.map
