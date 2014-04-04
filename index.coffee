module.exports = WatchBuilder = (grunt) ->
  _ = require 'lodash'
  path = require 'path'
  walkTree = require './lib/walk_tree'

  inside = (newDir, callback) ->
    prevDir = process.cwd()
    grunt.file.setBase newDir
    callback -> grunt.file.setBase(prevDir)

  # Task configuration
  grunt.initConfig watch: walkTree('./', {
    options:
      spawn: false
    livereload:
      options:
        livereload: true
      files: [
        'build/www/css/**/*.css'
        'build/www/js/**/*.js'
        'build/www/index.html'
      ]
  })

  inside __dirname, (done) ->
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
