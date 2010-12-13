{doublePixels, doubledCoords} = require 'postprocess'

describe 'basic looping', ->
    it 'should cover all values', ->
        v = []
        w = 4
        x = w/2
        while x--
            v.push x
        expect(v).toEqual [1, 0]
    # 0, 1
    # 2, 3
    it 'should enumerate in expected order', ->
        wHalf = 2
        hHalf = 2
        v = []
        y = hHalf
        while y--
            x = wHalf
            yOffset = 2*y
            while x--
                v.push x + yOffset
        expect(v).toEqual [3, 2, 1, 0]

describe 'doubled pixel coord transformations', ->
    it 'should return (0,0) in various widths', ->
        # r00, g00, b00, a00, r01, g01, b01, a01
        # r10, g10, b10, a10, r11, g11, b11, a11
        expect(doubledCoords 0, 0, 2, 2).toEqual [
            0, 4
            8, 12
        ]
        # 0, 1, 2
        # 3, 4, 5
        # 6, 7, 8
        expect(doubledCoords 0, 0, 3, 3).toEqual [
            0, 4
            12, 16
        ]
        # 0, 1, 2, 3
        # 4, 5, 6, 7
        # 8, 9, 0, 1
        # 2, 3, 4, 5
        expect(doubledCoords 0, 0, 4, 4).toEqual [
            0, 4
            16, 20
        ]
    it 'should return (1, 0) in various widths', ->
        expect(doubledCoords 1, 0, 4, 4).toEqual [
            8, 12
            24, 28
        ]
        # 0, 1, 2, 3, 4
        # 5, 6, 7, 8, 9
        #expect(doubledCoords 1, 0, 5, 5).toEqual [2, 3, 7, 8]
    it 'should return (0, 1) in various widths', ->
        expect(doubledCoords 0, 1, 4, 4).toEqual [
            32, 36
            48, 52
        ]

describe 'doubling pixels in an array', ->
    it 'should double a 2*2 array', ->
        data = [
            1.1, 1.2, 1.3, 1.4, 0.0, 0.0, 0.0, 0.0
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        ]
        expect(doublePixels data, 2, 2).toEqual [
            1.1, 1.2, 1.3, 1.4, 1.1, 1.2, 1.3, 1.4
            1.1, 1.2, 1.3, 1.4, 1.1, 1.2, 1.3, 1.4
        ]

    it 'should double a 2*2 array in place', ->
        data = [
            1.1, 1.2, 1.3, 1.4, 0.0, 0.0, 0.0, 0.0
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        ]
        doublePixels data, 2, 2
        expect(data).toEqual [
            1.1, 1.2, 1.3, 1.4, 1.1, 1.2, 1.3, 1.4
            1.1, 1.2, 1.3, 1.4, 1.1, 1.2, 1.3, 1.4
        ]

    it 'should double a 4*4 array', ->
        pixels = [
            1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
            3.1, 3.2, 3.3, 3.4, 4.1, 4.2, 4.3, 4.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        ]
        n = pixels.length
        doublePixels pixels, 4, 4
        expect(pixels.length).toEqual n
        expect(pixels).toEqual [
            1.1, 1.2, 1.3, 1.4, 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.1, 2.2, 2.3, 2.4
            1.1, 1.2, 1.3, 1.4, 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.1, 2.2, 2.3, 2.4
            3.1, 3.2, 3.3, 3.4, 3.1, 3.2, 3.3, 3.4, 4.1, 4.2, 4.3, 4.4, 4.1, 4.2, 4.3, 4.4
            3.1, 3.2, 3.3, 3.4, 3.1, 3.2, 3.3, 3.4, 4.1, 4.2, 4.3, 4.4, 4.1, 4.2, 4.3, 4.4
        ]
