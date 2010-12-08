(function() {
  var Rectangle, config, drawBackgroundOn, drawOn, gloop, rectangles, update, x, _results;
  Rectangle = require('./rectangle').Rectangle;
  config = require('./config');
  exports.config = config;
  exports.start = function(screen) {
    var context;
    context = screen.getContext('2d');
    return window.setInterval(gloop(context), config.dt);
  };
  rectangles = (function() {
    _results = [];
    for (x = 1; x <= 200; x++) {
      _results.push(new Rectangle());
    }
    return _results;
  }());
  drawBackgroundOn = function(context) {
    var lingrad;
    lingrad = context.createLinearGradient(0, 0, 0, config.height);
    lingrad.addColorStop(0, 'green');
    lingrad.addColorStop(1, 'black');
    context.fillStyle = lingrad;
    return context.fillRect(0, 0, config.width, config.height);
  };
  drawOn = function(context) {
    var rectangle, _i, _len, _results;
    drawBackgroundOn(context);
    _results = [];
    for (_i = 0, _len = rectangles.length; _i < _len; _i++) {
      rectangle = rectangles[_i];
      _results.push(rectangle.drawOn(context));
    }
    return _results;
  };
  update = function(dt) {
    var rectangle, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = rectangles.length; _i < _len; _i++) {
      rectangle = rectangles[_i];
      _results.push(rectangle.update());
    }
    return _results;
  };
  gloop = function(context) {
    return function() {
      drawOn(context);
      return update(config.dt);
    };
  };
}).call(this);
