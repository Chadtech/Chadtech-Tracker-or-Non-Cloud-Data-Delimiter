gulp          = require 'gulp'
jade          = require 'gulp-jade'
stylus        = require 'gulp-stylus'
coffee        = require 'gulp-coffee'
autowatch     = require 'gulp-autowatch'
childProcess  = require 'child_process'

launchWebkit = ->

  logOutput = (err, stdout, stderr) ->
    if err
      console.log err
    else
      console.log 'STDOUT: ', stdout
      console.log 'STDERR: ', stderr

  nwCommand = './nwjs.app/Contents/MacOS/nwjs'
  childProcess.exec nwCommand, logOutput

paths =
  resources: './resources'
  coffee:    './src/js/*.coffee'
  jade:      './src/html/*.jade'
  stylus:    './src/css/*.styl'

resources = './resources'

gulp.task 'coffee', ->
  gulp.src paths.coffee
  .pipe coffee()
  .pipe gulp.dest resources


gulp.task 'jade', ->
  gulp.src paths.jade
  .pipe jade()
  .pipe gulp.dest resources

gulp.task 'stylus', ->
  gulp.src paths.stylus
  .pipe stylus()
  .pipe gulp.dest resources

gulp.task 'watch', ->
  autowatch gulp, paths
  launchWebkit()

# gulp.task 'server', (cb) ->
#   require './server'

gulp.task 'default', 
  ['coffee', 'jade', 'watch']




