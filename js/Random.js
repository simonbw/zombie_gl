// Generated by CoffeeScript 1.8.0
(function() {
  window.Random = (function() {
    function Random() {}

    Random.bool = function(chance) {
      if (chance == null) {
        chance = 0.5;
      }
      return Math.random() < chance;
    };

    Random.normal = function(variance, mean) {
      if (variance == null) {
        variance = 1.0;
      }
      if (mean == null) {
        mean = 0.0;
      }
      return (Math.random() + Math.random() + Math.random() - 1.5) * variance + mean;
    };

    Random.int = function(min, max) {
      return Math.floor(Math.random() * (max - min) + max);
    };

    Random.uniform = function(min, max) {
      return Math.random() * (max - min) + max;
    };

    return Random;

  })();

}).call(this);

//# sourceMappingURL=Random.js.map
