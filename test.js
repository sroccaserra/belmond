#!/usr/bin/env node

require.paths.unshift('./lib'),
require.paths.unshift('./src'),

require('coffee-script');
require('jasmine');
require('villain');

var target = "";

if(process.argv[2]) {
  if(!require('fs').statSync(process.argv[2]).isFile()) {
    target = process.argv[2];
  } else {
    target = __dirname + "/" + process.argv[2];
  }
} else {
  target = process.cwd() + '/spec';
}

jasmine.executeSpecsInFolder(target, function(runner, log){
  process.exit(runner.results().failedCount);
}, false, true, "_spec.coffee$");
