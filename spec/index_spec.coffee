index = require 'index'

describe 'free fall path', ->

    it 'should start at y0 = 0', ->
        path = index.freeFall 1, 2
        expect(path[0]).toEqual 0

    it 'should half at yMax', ->
        n = 20
        yLast = index.freeFall(1, n)[n-1]
        expect(yLast).toEqual 1
        yLast = index.freeFall(10, n)[n-1]
        expect(yLast).toEqual 10

    it 'should roll back after half', ->
        n = 4
        path = index.freeFall(1, n)
        expect(path[n-2]).toEqual path[n]

    it 'should have 2n-1 steps', ->
        path = index.freeFall 1, 10
        expect(path.length).toEqual 19

    it 'should end with 0', ->
        path = index.freeFall 1, 10
        expect(path[18]).toEqual 0

