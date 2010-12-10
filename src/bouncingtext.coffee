freefall = require './freefall'

class BouncingText
    constructor: (text, xCenter, yStart, yAmplitude) ->
        @text = text
        @xCenter = xCenter
        @yStart = yStart
        @yAmplitude = yAmplitude
        @yPath = freefall.mirroredFreeFall @yAmplitude, 20
        @textHeightIndex = 0
        @alpha = 0

    drawOn: (context) ->
        context.font = "10pt Arial"
        context.textAlign = "center"
        context.shadowOffsetX = 5
        context.shadowOffsetY = 5
        context.shadowBlur = 5
        context.shadowColor = "rgba(0, 0, 0, 0.7)"
        context.fillStyle = "rgba(100, 255, 100, 1)"
        x = @xCenter + 200*Math.sin @alpha
        y = @yStart + @yPath[@textHeightIndex]
        context.fillText(@text, x, y)

    update: ->
        @textHeightIndex = @textHeightIndex + 1
        if @textHeightIndex >= @yPath.length
            @textHeightIndex = 0
        @alpha = @alpha+0.01


exports.BouncingText = BouncingText
