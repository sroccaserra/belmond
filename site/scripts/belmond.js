(function() {
  var require;
  require = function(path) {
    var m, originalPath;
    originalPath = path;
    if (!(m = require.modules[path])) {
      path += '/index';
      if (!(m = require.modules[path])) {
        throw "Couldn't find module for: " + originalPath;
      }
    }
    if (!m.exports) {
      m.exports = {};
      m.call(m.exports, m, m.exports, require.bind(path));
    }
    return m.exports;
  };
  require.modules = {};
  require.bind = function(path) {
    return function(p) {
      var cwd, part, _i, _len, _ref;
      if (p.charAt(0) !== '.') {
        return require(p);
      }
      cwd = path.split('/');
      cwd.pop();
      _ref = p.split('/');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        part = _ref[_i];
        if (part === '..') {
          cwd.pop();
        } else {
          if (part !== '.') {
            cwd.push(part);
          }
        }
      }
      return require(cwd.join('/'));
    };
  };
  require.module = function(path, fn) {
    return require.modules[path] = fn;
  };
  window.require = require;
}).call(this);
require.module('main/index', function(module, exports, require) {
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
      _results.push(new Rectangle(config.height));
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
      _results.push(rectangle.update(config.width));
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

});
require.module('main/rectangle', function(module, exports, require) {
(function() {
  var Rectangle;
  Rectangle = function() {
    function Rectangle(screenHeight) {
      var maxHeight, minHeight, randomColor;
      minHeight = 0;
      maxHeight = screenHeight / 2;
      randomColor = parseInt(Math.random() * 255);
      this.width = 5 + Math.random() * 60;
      this.height = minHeight + Math.random() * (maxHeight - minHeight);
      this.speed = 1 + Math.random() * 8;
      this.style = "rgba(10, " + randomColor + ", 10, " + (Math.random()) + ")";
      this.y = -this.height + Math.random() * (screenHeight + this.height);
      this.x = -this.width * 20;
    }
    Rectangle.prototype.reset = function() {
      return this.x = -this.width;
    };
    Rectangle.prototype.update = function(xMax) {
      this.x = this.x + this.speed;
      if (this.x > xMax) {
        return this.reset();
      }
    };
    Rectangle.prototype.drawOn = function(context) {
      context.fillStyle = this.style;
      return context.fillRect(this.x, this.y, this.width, this.height);
    };
    return Rectangle;
  }();
  exports.Rectangle = Rectangle;
}).call(this);

});
require.module('main/config', function(module, exports, require) {
(function() {
  exports.width = 1000;
  exports.height = 100;
  exports.dt = 100 / 6;
}).call(this);

});
