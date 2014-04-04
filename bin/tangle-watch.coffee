#!/usr/bin/env coffee
 
exports.command =
  description: 'Watch files for changes and rebuild'

if require.main is module
  path = require 'path'
  grunt = require 'grunt'

  grunt.cli
    gruntfile: path.join(__dirname, '..', 'index.coffee')
    base: process.cwd()
