{doublePixels, doubledCoords} = require 'postprocess'

describe 'doubling pixels in an array', ->
    it 'should double a 2*2 array', ->
        expect(doublePixels [1, 0, 0, 0], 2, 2).toEqual [1, 1, 1, 1]
        expect(doublePixels [2, 0, 0, 0], 2, 2).toEqual [2, 2, 2, 2]

    it 'should double a 2*2 array in place', ->
        pixels = [1, 0, 0, 0]
        doublePixels pixels, 2, 2
        expect(pixels).toEqual [1, 1, 1, 1]

    it 'should double a 4*4 array', ->
        pixels = [
            1, 2, 0, 0
            3, 4, 0, 0
            0, 0, 0, 0
            0, 0, 0, 0
        ]
        n = pixels.length
        doublePixels pixels, 4, 4
        expect(pixels.length).toEqual n
        expect(pixels).toEqual [
            1, 1, 2, 2
            1, 1, 2, 2
            3, 3, 4, 4
            3, 3, 4, 4
        ]

describe 'basic looping', ->
    # 0, 1
    # 2, 3
    it 'should enumerate in expected order', ->
        v = []
        for y in [1..0]
            for x in [1..0]
                v.push x+2*y
        expect(v).toEqual [3, 2, 1, 0]

describe 'doubled pixel coord transformations', ->
    it 'should return (0,0) in various widths', ->
        # 0, 1
        # 2, 3
        expect(doubledCoords 0, 0, 2, 2).toEqual [0, 1, 2, 3]
        # 0, 1, 2
        # 3, 4, 5
        # 6, 7, 8
        expect(doubledCoords 0, 0, 3, 3).toEqual [0, 1, 3, 4]
        # 0, 1, 2, 3
        # 4, 5, 6, 7
        # 8, 9, 0, 1
        # 2, 3, 4, 5
        expect(doubledCoords 0, 0, 4, 4).toEqual [0, 1, 4, 5]
    it 'should return (1, 0) in various widths', ->
        expect(doubledCoords 1, 0, 4, 4).toEqual [2, 3, 6, 7]
        # 0, 1, 2, 3, 4
        # 5, 6, 7, 8, 9
        expect(doubledCoords 1, 0, 5, 5).toEqual [2, 3, 7, 8]
    it 'should return (0, 1) in various widths', ->
        expect(doubledCoords 0, 1, 4, 4).toEqual [8, 9, 12, 13]

