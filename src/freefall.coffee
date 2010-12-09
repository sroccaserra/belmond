exports.freeFall = (yMax, nbSteps) ->
    if nbSteps is 1
        return [0]
    middleIndex = nbSteps - 1
    a = yMax/(middleIndex*middleIndex)
    path = (a*x*x for x in [0..middleIndex])
    path

exports.mirror = (array) ->
    copy = array[0...array.length]
    if array.length < 2
        return copy
    middleIndex = copy.length - 1
    copy[2*middleIndex-n] = copy[n] for n in [middleIndex-1..0]
    copy

exports.mirroredFreeFall = (yMax, nbSteps) ->
    fall = exports.freeFall yMax, nbSteps
    exports.mirror fall

