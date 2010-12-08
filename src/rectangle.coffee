##
# Rectangle definition

class Rectangle
    constructor: (screenHeight)->
        minHeight = 0
        maxHeight = screenHeight/2

        randomColor = parseInt Math.random()*255

        @width = 5 + Math.random()*60
        @height = minHeight + Math.random()*(maxHeight - minHeight)
        @speed = 1 + Math.random()*8
        @style = "rgba(10, #{randomColor}, 10, #{Math.random()})"

        @y = -@height + Math.random()*(screenHeight + @height)
        @x = -@width * 20

    reset: ->
        @x = -@width

    update: (xMax) ->
        @x = @x + @speed
        if @x > xMax
            this.reset()

    drawOn: (context) ->
        context.fillStyle = @style
        context.fillRect @x, @y, @width, @height

exports.Rectangle = Rectangle
