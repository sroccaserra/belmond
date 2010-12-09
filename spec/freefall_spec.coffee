freefall = require 'freefall'

describe 'mirror', ->
    it 'should return a one elem array unchanged', ->
        expect(freefall.mirror [0]).toEqual [0]
        expect(freefall.mirror []).toEqual []

    it 'should copy the array', ->
        a = [1]
        copy = freefall.mirror a
        expect(copy).not.toBe a

    it 'should mirror an array', ->
        expect(freefall.mirror [0, 1]).toEqual [0, 1, 0]
        expect(freefall.mirror [0, 1, 2]).toEqual [0, 1, 2, 1, 0]

describe 'Free fall path', ->

    it 'should start at y0 = 0', ->
        fall = freefall.freeFall 1, 2
        expect(fall[0]).toEqual 0

    it 'should end at yMax', ->
        n = 20
        yLast = freefall.freeFall(1, n)[n-1]
        expect(yLast).toEqual 1

        yLast = freefall.freeFall(10, n)[n-1]
        expect(yLast).toEqual 10

    describe 'Mirrored free fall', ->
        it 'should roll back after half', ->
            n = 4
            path = freefall.mirroredFreeFall 1, n
            expect(path[n-2]).toEqual path[n]

        it 'should have 2n-1 steps', ->
            path = freefall.mirroredFreeFall 1, 10
            expect(path.length).toEqual 19

        it 'should end with 0', ->
            path = freefall.mirroredFreeFall 1, 10
            expect(path[18]).toEqual 0
