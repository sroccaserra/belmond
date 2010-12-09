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
  var Rectangle, alpha, config, drawBackgroundOn, drawOn, drawTextOn, gloop, rectangles, textHeightIndex, textMaxHeight, textPath, update, x, _results;
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
    lingrad.addColorStop(0, 'rgba(0, 0, 0, 1)');
    lingrad.addColorStop(0.25, 'rgba(0, 50, 0, 1)');
    lingrad.addColorStop(0.60, 'rgba(0, 100, 0, 1)');
    lingrad.addColorStop(1, 'rgba(0, 0, 0, 1)');
    context.fillStyle = "rgba(0, 0, 0, 1)";
    context.fillStyle = lingrad;
    return context.fillRect(0, 0, config.width, config.height);
  };
  exports.freeFall = function(yMax, nbSteps) {
    var a, middleIndex, n, path, x, _ref, _results;
    if (nbSteps === 1) {
      return [0];
    }
    middleIndex = nbSteps - 1;
    a = yMax / (middleIndex * middleIndex);
    path = (function() {
      _results = [];
      for (x = 0; (0 <= middleIndex ? x <= middleIndex : x >= middleIndex); (0 <= middleIndex ? x += 1 : x -= 1)) {
        _results.push(a * x * x);
      }
      return _results;
    }());
    for (n = _ref = middleIndex - 1; (_ref <= 0 ? n <= 0 : n >= 0); (_ref <= 0 ? n += 1 : n -= 1)) {
      path[2 * middleIndex - n] = path[n];
    }
    return path;
  };
  textMaxHeight = config.height * .75;
  textPath = exports.freeFall(textMaxHeight, 20);
  textHeightIndex = 0;
  alpha = 0;
  drawTextOn = function(context) {
    var y;
    context.font = "20pt Arial";
    context.textAlign = "center";
    context.shadowOffsetX = 5;
    context.shadowOffsetY = 5;
    context.shadowBlur = 5;
    context.shadowColor = "rgba(0, 0, 0, 0.7)";
    context.fillStyle = "rgba(100, 255, 100, 1)";
    x = config.width / 2 + 200 * Math.sin(alpha);
    y = textPath[textHeightIndex] + config.height - textMaxHeight;
    return context.fillText("Belmond v0.0.1", x, y);
  };
  drawOn = function(context) {
    var rectangle, _i, _len, _results;
    drawBackgroundOn(context);
    drawTextOn(context);
    context.shadowOffsetX = null;
    context.shadowOffsetY = null;
    context.shadowBlur = null;
    context.shadowColor = null;
    _results = [];
    for (_i = 0, _len = rectangles.length; _i < _len; _i++) {
      rectangle = rectangles[_i];
      _results.push(rectangle.drawOn(context));
    }
    return _results;
  };
  update = function(dt) {
    var rectangle, _i, _len;
    for (_i = 0, _len = rectangles.length; _i < _len; _i++) {
      rectangle = rectangles[_i];
      rectangle.update(config.width);
    }
    textHeightIndex = textHeightIndex + 1;
    if (textHeightIndex >= textPath.length) {
      textHeightIndex = 0;
    }
    return alpha = alpha + 0.01;
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
