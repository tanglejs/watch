module.exports = WatchBuilder = (grunt) ->
  _ = require 'lodash'
  path = require 'path'
  walkTree = require './lib/walk_tree'
  inside = require('tangle-util/grunt').inside

  # Task configuration
  grunt.initConfig watch: walkTree('./', {
    options:
      spawn: false
    livereload:
      options:
        livereload: true
      files: [
        'build/app/**/*.css'
        'build/app/**/*.js'
        'build/app/index.html'
      ]
  })

  inside __dirname, grunt, (done) ->
    grunt.loadNpmTasks 'grunt-contrib-watch'
    done()

  grunt.registerTask 'build:app', (args...) ->
    grunt.util.spawn
      cmd: 'tangle-app-build'
      args: args.join(':')
    , (error, result, code) ->
      if error? then grunt.fail.warn error 
      console.log result.stdout

  grunt.registerTask 'default', ['watch']
