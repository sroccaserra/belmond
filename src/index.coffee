#
# Small stuff to learn HTML5 canvas and CoffeeScript
#

Rectangle = require('./rectangle').Rectangle
config = require './config'

# Public stuff
exports.config = config

exports.start = (screen)->
    context = screen.getContext '2d'
    window.setInterval gloop(context), config.dt

# Some rectangles to draw
rectangles = (new Rectangle(config.height) for x in [1..200])

# game loop functions
drawBackgroundOn = (context) ->
    lingrad = context.createLinearGradient 0, 0, 0, config.height
    lingrad.addColorStop 0, 'green'
    lingrad.addColorStop 1, 'black'
    context.fillStyle = lingrad
    context.fillRect 0, 0, config.width, config.height

drawOn = (context) ->
    drawBackgroundOn context
    rectangle.drawOn context for rectangle in rectangles

update = (dt) ->
    rectangle.update(config.width) for rectangle in rectangles

gloop = (context) ->
    ->
        drawOn context
        update config.dt
