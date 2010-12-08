config = require 'config'

describe 'config', ->
    it 'must not have false values', ->
        expect(config.vvvvvv + 1).toBeFalsy()
    it 'should define a width', ->
        expect(config.width).toBeDefined()

