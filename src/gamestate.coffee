postprocess = require './postprocess'
{BouncingText} = require './bouncingtext'
{Rectangle} = require './rectangle'
{NeonText} = require './neontext'

class GameState
    constructor: (width, height, version, @dt) ->
        @width = width/2
        @height = height/2
        @isPaused = false
        @isFiltered = false
        @bouncingText = new BouncingText(
            "Belmond",
            @width/2,
            @height*.25,
            @height*.75)
        @rectangles = (new Rectangle(@height) for x in [1..100])
        @neonText = new NeonText version

    start: (context) ->
        window.addEventListener 'keyup', @onKeyUp, true
        @loopId = window.setInterval( =>
            @drawOn context
            @update @dt
        , @dt)

    stop: ->
        window.removeEventListener 'keyup', @onKeyUp, true
        window.clearInterval @loopId

    drawBackgroundOn: (context) ->
        lingrad = context.createLinearGradient 0, 0, 0, @height
        lingrad.addColorStop 0, 'rgba(0, 0, 0, 1)'
        lingrad.addColorStop 0.25, 'rgba(0, 50, 0, 1)'
        lingrad.addColorStop 0.60, 'rgba(0, 100, 0, 1)'
        lingrad.addColorStop 1, 'rgba(0, 0, 0, 1)'
        context.fillStyle = "rgba(0, 0, 0, 1)" # Chrome seems to use alpha from last fill style
        context.fillStyle = lingrad
        context.fillRect 0, 0, @width, @height

    clearShadows: (context) ->
        context.shadowOffsetX = null
        context.shadowOffsetY = null
        context.shadowBlur = null
        context.shadowColor = null

    drawOn: (context) ->
        @drawBackgroundOn context
        @bouncingText.drawOn context
        @clearShadows context
        rectangle.drawOn context for rectangle in @rectangles
        @neonText.drawOn context, @width - 10, @height - 10
        @clearShadows context
        if @isFiltered
            canvas = context.canvas
            context.drawImage canvas, 0, 0, canvas.width*2, canvas.height*2
        else
            canvas = context.canvas
            imageData = context.getImageData 0, 0, canvas.width, canvas.height
            postprocess.doublePixels imageData.data, canvas.width, canvas.height
            context.putImageData imageData, 0, 0

    update: (dt) ->
        if @isPaused
            return
        @bouncingText.update()
        rectangle.update(@width) for rectangle in @rectangles
        @neonText.update()

    onKeyUp: (event) =>
        SPACE = 32
        F = 70
        if event.keyCode is SPACE
            @isPaused = not @isPaused
        else if event.keyCode is F
            @isFiltered = not @isFiltered
        else if event.keyCode is 83
            @stop()


exports.GameState = GameState
