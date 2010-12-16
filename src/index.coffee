#
# Small stuff to learn HTML5 canvas and CoffeeScript
#

config = require './config'
{GameState} = require './gamestate'

# Public stuff
exports.config = config

exports.start = (screen)->
    context = screen.getContext '2d'
    gameState = new GameState config.width, config.height, config.version, config.dt
    gameState.start(context)
