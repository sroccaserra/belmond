exports.doublePixels = (pixels, w, h) ->
    wHalf = w/2
    hHalf = h/2
    for y in [hHalf-1..0]
        for x in [wHalf-1..0]
            i = 4*(x+w*y)
            r = pixels[i]
            g = pixels[i+1]
            b = pixels[i+2]
            a = pixels[i+3]
            doubledIndexes = exports.doubledCoords x, y, w, h
            for k in doubledIndexes
                pixels[k] = r
                pixels[k+1] = g
                pixels[k+2] = b
                pixels[k+3] = a
    pixels

exports.doubledCoords = (x, y, w, h) ->
    p0 = 8*(x + y*w)
    p1 = p0+4
    p2 = p0+w*4
    p3 = p2+4
    [
        p0, p1
        p2, p3
    ]
