##
# Rectangle definition

config = require './config'

class Rectangle
    constructor: ->
        minHeight = 0
        maxHeight = config.height/2

        randomColor = parseInt Math.random()*255

        @width = 5 + Math.random()*60
        @height = minHeight + Math.random()*(maxHeight - minHeight)
        @speed = 1 + Math.random()*8
        @style = "rgba(10, #{randomColor}, 10, #{Math.random()})"

        @y = -@height + Math.random()*(config.height + @height)
        @x = -@width * 20

    reset: ->
        @x = -@width

    update: ->
        @x = @x + @speed
        if @x > config.width
            this.reset()

    drawOn: (context) ->
        context.fillStyle = @style
        context.fillRect @x, @y, @width, @height

exports.Rectangle = Rectangle
