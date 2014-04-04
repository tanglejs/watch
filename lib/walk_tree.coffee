path = require 'path'
config = require 'tangle-config'
_ = require 'lodash'

watchProject = (dir, @tasks, prefix) ->
  @tasks["#{prefix}-config.js"] =
    files: path.resolve path.join(dir, 'config.js')
    tasks: ['build:app:components']

  @tasks["#{prefix}-tangle.json"] =
    files: path.resolve path.join(dir, 'tangle.json')
    tasks: ['build:app:default']

watchApp = (dir, @tasks, prefix) ->
  @tasks["#{prefix}-tangle.json"] =
    files: path.resolve path.join(dir, 'tangle.json')
    tasks: ['build:app:default']

  @tasks["#{prefix}-styl"] =
    files: path.resolve path.join(dir, 'styl', '**/*.styl')
    tasks: ['build:app:stylus:app']

  @tasks["#{prefix}-coffee"] =
    files: [path.resolve path.join(dir, '*.coffee')]
    tasks: ['build:app:coffee']

  @tasks["#{prefix}-jade"] =
    files: [path.resolve path.join(dir, '*.jade')]
    tasks: ['build:app:jade']

walkTree = (dir, @tasks={}) ->
  conf = config.getConf().file(path.join(dir, 'tangle.json'))
  switch conf.get('type')
    when 'project'
      watchProject dir, @tasks, "project-#{conf.get('name')}"
      @tasks = walkTree path.join(dir, 'app/'), @tasks

    when 'app'
      watchApp dir, @tasks, "app-#{conf.get('name')}"

      initializers = _.toArray conf.get('initializers')
      @tasks["app-#{conf.get('name')}-initializers"] =
        files: initializers
        tasks: ['build:app:initializers']

      _.each conf.get('modules'), (module) =>
        @tasks = walkTree path.resolve(module), @tasks

      _.each conf.get('primitives'), (primitive) =>
        @tasks = walkTree path.resolve(module), @tasks

    #when 'module'
      # TODO

    #when 'primitive'
      # TODO

  return @tasks

module.exports = walkTree
