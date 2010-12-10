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
  var BouncingText, NeonText, Rectangle, bouncingText, clearShadows, config, drawBackgroundOn, drawOn, getGameLoop, height, neonText, postprocess, rectangles, update, width, x, _results;
  config = require('./config');
  postprocess = require('./postprocess');
  BouncingText = require('./bouncingtext').BouncingText;
  Rectangle = require('./rectangle').Rectangle;
  NeonText = require('./neontext').NeonText;
  exports.config = config;
  exports.start = function(screen) {
    var context;
    context = screen.getContext('2d');
    return window.setInterval(getGameLoop(context), config.dt);
  };
  width = config.width / 2;
  height = config.height / 2;
  bouncingText = new BouncingText("Belmond", width / 2, height * .25, height * .75);
  rectangles = (function() {
    _results = [];
    for (x = 1; x <= 100; x++) {
      _results.push(new Rectangle(height));
    }
    return _results;
  }());
  neonText = new NeonText(config.version);
  drawBackgroundOn = function(context) {
    var lingrad;
    lingrad = context.createLinearGradient(0, 0, 0, height);
    lingrad.addColorStop(0, 'rgba(0, 0, 0, 1)');
    lingrad.addColorStop(0.25, 'rgba(0, 50, 0, 1)');
    lingrad.addColorStop(0.60, 'rgba(0, 100, 0, 1)');
    lingrad.addColorStop(1, 'rgba(0, 0, 0, 1)');
    context.fillStyle = "rgba(0, 0, 0, 1)";
    context.fillStyle = lingrad;
    return context.fillRect(0, 0, width, height);
  };
  clearShadows = function(context) {
    context.shadowOffsetX = null;
    context.shadowOffsetY = null;
    context.shadowBlur = null;
    return context.shadowColor = null;
  };
  drawOn = function(context) {
    var imageData, rectangle, _i, _len;
    drawBackgroundOn(context);
    bouncingText.drawOn(context);
    clearShadows(context);
    for (_i = 0, _len = rectangles.length; _i < _len; _i++) {
      rectangle = rectangles[_i];
      rectangle.drawOn(context);
    }
    neonText.drawOn(context, width - 10, height - 10);
    clearShadows(context);
    imageData = context.getImageData(0, 0, config.width, config.height);
    postprocess.doublePixels(imageData.data, config.width, config.height);
    return context.putImageData(imageData, 0, 0);
  };
  update = function(dt) {
    var rectangle, _i, _len;
    bouncingText.update();
    for (_i = 0, _len = rectangles.length; _i < _len; _i++) {
      rectangle = rectangles[_i];
      rectangle.update(width);
    }
    return neonText.update();
  };
  getGameLoop = function(context) {
    return function() {
      drawOn(context);
      return update(config.dt);
    };
  };
}).call(this);

});
require.module('main/config', function(module, exports, require) {
(function() {
  exports.width = 1000;
  exports.height = 100;
  exports.dt = 100 / 5;
  exports.version = "v0.0.2";
}).call(this);

});
require.module('main/postprocess', function(module, exports, require) {
(function() {
  exports.doublePixels = function(pixels, w, h) {
    var a, b, doubledIndexes, g, hHalf, i, k, r, wHalf, x, y, _i, _len, _ref, _ref2;
    wHalf = w / 2;
    hHalf = h / 2;
    for (y = _ref = hHalf - 1; (_ref <= 0 ? y <= 0 : y >= 0); (_ref <= 0 ? y += 1 : y -= 1)) {
      for (x = _ref2 = wHalf - 1; (_ref2 <= 0 ? x <= 0 : x >= 0); (_ref2 <= 0 ? x += 1 : x -= 1)) {
        i = 4 * (x + w * y);
        r = pixels[i];
        g = pixels[i + 1];
        b = pixels[i + 2];
        a = pixels[i + 3];
        doubledIndexes = exports.doubledCoords(x, y, w, h);
        for (_i = 0, _len = doubledIndexes.length; _i < _len; _i++) {
          k = doubledIndexes[_i];
          pixels[k] = r;
          pixels[k + 1] = g;
          pixels[k + 2] = b;
          pixels[k + 3] = a;
        }
      }
    }
    return pixels;
  };
  exports.doubledCoords = function(x, y, w, h) {
    var p0, p1, p2, p3;
    p0 = 8 * (x + y * w);
    p1 = p0 + 4;
    p2 = p0 + w * 4;
    p3 = p2 + 4;
    return [p0, p1, p2, p3];
  };
}).call(this);

});
require.module('main/bouncingtext', function(module, exports, require) {
(function() {
  var BouncingText, freefall;
  freefall = require('./freefall');
  BouncingText = function() {
    function BouncingText(text, xCenter, yStart, yAmplitude) {
      this.text = text;
      this.xCenter = xCenter;
      this.yStart = yStart;
      this.yAmplitude = yAmplitude;
      this.yPath = freefall.mirroredFreeFall(this.yAmplitude, 20);
      this.textHeightIndex = 0;
      this.alpha = 0;
    }
    BouncingText.prototype.drawOn = function(context) {
      var x, y;
      context.font = "10pt Arial";
      context.textAlign = "center";
      context.shadowOffsetX = 5;
      context.shadowOffsetY = 5;
      context.shadowBlur = 5;
      context.shadowColor = "rgba(0, 0, 0, 0.7)";
      context.fillStyle = "rgba(100, 255, 100, 1)";
      x = this.xCenter + 200 * Math.sin(this.alpha);
      y = this.yStart + this.yPath[this.textHeightIndex];
      return context.fillText(this.text, x, y);
    };
    BouncingText.prototype.update = function() {
      this.textHeightIndex = this.textHeightIndex + 1;
      if (this.textHeightIndex >= this.yPath.length) {
        this.textHeightIndex = 0;
      }
      return this.alpha = this.alpha + 0.01;
    };
    return BouncingText;
  }();
  exports.BouncingText = BouncingText;
}).call(this);

});
require.module('main/freefall', function(module, exports, require) {
(function() {
  exports.freeFall = function(yMax, nbSteps) {
    var a, middleIndex, path, x, _results;
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
    return path;
  };
  exports.mirror = function(array) {
    var copy, middleIndex, n, _ref;
    copy = array.slice(0, array.length);
    if (array.length < 2) {
      return copy;
    }
    middleIndex = copy.length - 1;
    for (n = _ref = middleIndex - 1; (_ref <= 0 ? n <= 0 : n >= 0); (_ref <= 0 ? n += 1 : n -= 1)) {
      copy[2 * middleIndex - n] = copy[n];
    }
    return copy;
  };
  exports.mirroredFreeFall = function(yMax, nbSteps) {
    var fall;
    fall = exports.freeFall(yMax, nbSteps);
    return exports.mirror(fall);
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
require.module('main/neontext', function(module, exports, require) {
(function() {
  var NeonText;
  NeonText = function() {
    function NeonText(text) {
      this.text = text;
      this.state = false;
      this.styles = {};
      this.styles[true] = "rgb(255, 200, 200)";
      this.styles[false] = "rgb(200, 200, 200)";
    }
    NeonText.prototype.drawOn = function(context, x, y) {
      context.font = "bold 7pt Arial";
      context.textAlign = "right";
      context.fillStyle = this.styles[this.state];
      if (this.state) {
        context.shadowBlur = 10;
        context.shadowColor = "rgba(255, 200, 200, 1)";
        context.fillText(this.text, x, y);
        context.fillText(this.text, x, y);
        context.fillText(this.text, x, y);
      }
      return context.fillText(this.text, x, y);
    };
    NeonText.prototype.update = function() {
      return this.state = !this.state;
    };
    return NeonText;
  }();
  exports.NeonText = NeonText;
}).call(this);

});
