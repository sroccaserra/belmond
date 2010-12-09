
class NeonText
    constructor: (text) ->
        @text = text
        @state = off
        @styles = {}
        @styles[on] = "rgb(255, 200, 200)"
        @styles[off] = "rgb(200, 200, 200)"

    drawOn: (context, x, y) ->
        context.font = "bold 15pt Arial"
        context.textAlign = "right"
        context.fillStyle = @styles[@state]
        if @state
            context.shadowBlur = 10
            context.shadowColor = "rgba(255, 200, 200, 1)"
            context.fillText @text, x, y
            context.fillText @text, x, y
            context.fillText @text, x, y
        context.fillText @text, x, y

    update: ->
        @state = not @state

exports.NeonText = NeonText
