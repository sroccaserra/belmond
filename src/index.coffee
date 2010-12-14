#
# Small stuff to learn HTML5 canvas and CoffeeScript
#

config = require './config'
postprocess = require './postprocess'
{BouncingText} = require './bouncingtext'
{Rectangle} = require './rectangle'
{NeonText} = require './neontext'

# Public stuff
exports.config = config

exports.start = (screen)->
    context = screen.getContext '2d'
    window.setInterval getGameLoop(context), config.dt
    window.addEventListener 'keyup', onKeyUp, true

# state

width = config.width/2
height = config.height/2
isPaused = false
isFiltered = false

# A bouncing text and some rectangles to draw
bouncingText = new BouncingText(
    "Belmond",
    width/2,
    height*.25,
    height*.75)
rectangles = (new Rectangle(height) for x in [1..100])
neonText = new NeonText config.version

# game loop functions
drawBackgroundOn = (context) ->
    lingrad = context.createLinearGradient 0, 0, 0, height
    lingrad.addColorStop 0, 'rgba(0, 0, 0, 1)'
    lingrad.addColorStop 0.25, 'rgba(0, 50, 0, 1)'
    lingrad.addColorStop 0.60, 'rgba(0, 100, 0, 1)'
    lingrad.addColorStop 1, 'rgba(0, 0, 0, 1)'
    context.fillStyle = "rgba(0, 0, 0, 1)" # Chrome seems to use alpha from last fill style
    context.fillStyle = lingrad
    context.fillRect 0, 0, width, height

clearShadows = (context) ->
    context.shadowOffsetX = null
    context.shadowOffsetY = null
    context.shadowBlur = null
    context.shadowColor = null

drawOn = (context) ->
    drawBackgroundOn context
    bouncingText.drawOn context
    clearShadows context
    rectangle.drawOn context for rectangle in rectangles
    neonText.drawOn context, width-10, height-10
    clearShadows context
    if isFiltered
        context.drawImage context.canvas, 0, 0, config.width*2, config.height*2
    else
        imageData = context.getImageData 0, 0, config.width, config.height
        postprocess.doublePixels imageData.data, config.width, config.height
        context.putImageData imageData, 0, 0

update = (dt) ->
    if isPaused
        return
    bouncingText.update()
    rectangle.update(width) for rectangle in rectangles
    neonText.update()

onKeyUp = (event) ->
    SPACE = 32
    F = 70
    if event.keyCode is SPACE
        isPaused = not isPaused
    else if event.keyCode is F
        isFiltered = not isFiltered

getGameLoop = (context) ->
    ->
        drawOn context
        update config.dt
