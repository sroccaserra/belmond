exports.doublePixels = (pixels, w, h) ->
    wHalf = w/2
    hHalf = h/2
    for y in [hHalf-1..0]
        for x in [wHalf-1..0]
            pixel = pixels[x+w*y]
            doubledIndexes = exports.doubledCoords x, y, w, h
            for k in doubledIndexes
                pixels[k] = pixel
    pixels

exports.doubledCoords = (x, y, w, h) ->
    k0 = 2*(x + y*w)
    k1 = k0+1
    k2 = k0+w
    k3 = k2+1
    [k0, k1, k2, k3]
