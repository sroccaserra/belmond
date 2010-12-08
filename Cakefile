require.paths.unshift './lib'

fs = require 'fs'
path = require 'path'
{puts} = require 'sys'
{exec} = require 'child_process'

villainCake = require 'villain/build/cake'
villain = require 'villain'

BUNDLE_FILE = './site/scripts/bundle.js'

task 'bundle', 'Sorts the dependencies and bundles sources', ->
    invoke 'build'
    output = fs.createWriteStream BUNDLE_FILE
    villainLib = villain.getLibraryPath()
    villainCake.bundleSources output,
        env:
            'events': path.join villainLib, 'util', 'events.js'
        modules:
            'main':'./build'
        additional: [
            path.join villainLib, 'util', 'brequire.js'
        ]
    output.end()

task 'run', ->
    invoke 'bundle'
    exec 'cygstart site/index.html'

task 'build', ->
    villainCake.compileDirectory 'src', 'build'

task 'clean', ->
    exec 'rm -rf build/'
    exec "rm #{BUNDLE_FILE}"

task 'test', ->
    exec './test.js', (error, stdout, stderr)->
        puts stdout
