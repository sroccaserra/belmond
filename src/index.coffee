#
# Small stuff to learn HTML5 canvas and CoffeeScript
#

config = require './config'
BouncingText = require('./bouncingtext').BouncingText
Rectangle = require('./rectangle').Rectangle

# Public stuff
exports.config = config

exports.start = (screen)->
    context = screen.getContext '2d'
    window.setInterval gloop(context), config.dt

# Some rectangles to draw
bouncingText = new BouncingText(
    "Belmond v0.0.1",
    config.width/2,
    config.height*.25,
    config.height*.75)
rectangles = (new Rectangle(config.height) for x in [1..200])

# game loop functions
drawBackgroundOn = (context) ->
    lingrad = context.createLinearGradient 0, 0, 0, config.height
    lingrad.addColorStop 0, 'rgba(0, 0, 0, 1)'
    lingrad.addColorStop 0.25, 'rgba(0, 50, 0, 1)'
    lingrad.addColorStop 0.60, 'rgba(0, 100, 0, 1)'
    lingrad.addColorStop 1, 'rgba(0, 0, 0, 1)'
    context.fillStyle = "rgba(0, 0, 0, 1)" # Chrome seems to use alpha from last fill style
    context.fillStyle = lingrad
    context.fillRect 0, 0, config.width, config.height

drawOn = (context) ->
    drawBackgroundOn context
    bouncingText.drawOn context
    context.shadowOffsetX = null
    context.shadowOffsetY = null
    context.shadowBlur = null
    context.shadowColor = null
    rectangle.drawOn context for rectangle in rectangles

update = (dt) ->
    bouncingText.update()
    rectangle.update(config.width) for rectangle in rectangles

gloop = (context) ->
    ->
        drawOn context
        update config.dt

