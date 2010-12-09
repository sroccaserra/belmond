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
    lingrad.addColorStop 0, 'rgba(0, 0, 0, 1)'
    lingrad.addColorStop 0.25, 'rgba(0, 50, 0, 1)'
    lingrad.addColorStop 0.60, 'rgba(0, 100, 0, 1)'
    lingrad.addColorStop 1, 'rgba(0, 0, 0, 1)'
    context.fillStyle = "rgba(0, 0, 0, 1)" # Chrome seems to use alpha from last fill style
    context.fillStyle = lingrad
    context.fillRect 0, 0, config.width, config.height

exports.freeFall = (yMax, nbSteps) ->
    if nbSteps is 1
        return [0]
    middleIndex = nbSteps - 1
    a = yMax/(middleIndex*middleIndex)
    path = (a*x*x for x in [0..middleIndex])
    path[2*middleIndex-n] = path[n] for n in [middleIndex-1..0]
    path

textMaxHeight = config.height*.75
textPath = exports.freeFall(textMaxHeight, 20)
textHeightIndex = 0
alpha = 0

drawTextOn = (context) ->
    context.font = "20pt Arial"
    context.textAlign = "center"
    context.shadowOffsetX = 5
    context.shadowOffsetY = 5
    context.shadowBlur = 5
    context.shadowColor = "rgba(0, 0, 0, 0.7)"
    context.fillStyle = "rgba(100, 255, 100, 1)"
    x = config.width/2 + 200*Math.sin alpha
    y = textPath[textHeightIndex] + config.height - textMaxHeight
    context.fillText "Belmond v0.0.1", x, y

drawOn = (context) ->
    drawBackgroundOn context
    drawTextOn context
    context.shadowOffsetX = null
    context.shadowOffsetY = null
    context.shadowBlur = null
    context.shadowColor = null
    rectangle.drawOn context for rectangle in rectangles

update = (dt) ->
    rectangle.update(config.width) for rectangle in rectangles
    textHeightIndex = textHeightIndex + 1
    if textHeightIndex >= textPath.length
        textHeightIndex = 0
    alpha = alpha+0.01

gloop = (context) ->
    ->
        drawOn context
        update config.dt

