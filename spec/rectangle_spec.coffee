{Rectangle} = require 'rectangle'

describe 'Rectangle', ->
    it 'can be created', ->
        rect = new Rectangle(1000)
        expect(rect).toBeDefined()

        expect(rect.x).toBeDefined()
        expect(rect.x).toBeLessThan 0

        expect(rect.y).toBeDefined()
        expect(rect.y).toBeGreaterThan -rect.height
