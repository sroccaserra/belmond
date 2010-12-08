(function() {
  var Rectangle, config;
  config = require('./config');
  Rectangle = function() {
    function Rectangle() {
      var maxHeight, minHeight, randomColor;
      minHeight = 0;
      maxHeight = config.height / 2;
      randomColor = parseInt(Math.random() * 255);
      this.width = 5 + Math.random() * 60;
      this.height = minHeight + Math.random() * (maxHeight - minHeight);
      this.speed = 1 + Math.random() * 8;
      this.style = "rgba(10, " + randomColor + ", 10, " + (Math.random()) + ")";
      this.y = -this.height + Math.random() * (config.height + this.height);
      this.x = -this.width * 20;
    }
    Rectangle.prototype.reset = function() {
      return this.x = -this.width;
    };
    Rectangle.prototype.update = function() {
      this.x = this.x + this.speed;
      if (this.x > config.width) {
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
