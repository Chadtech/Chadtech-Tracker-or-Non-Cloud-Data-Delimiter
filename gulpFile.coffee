gulp          = require 'gulp'
jade          = require 'gulp-jade'
stylus        = require 'gulp-stylus'
coffee        = require 'gulp-coffee'
autowatch     = require 'gulp-autowatch'
concatenate   = require 'gulp-concat'
childProcess  = require 'child_process'
_             = require 'lodash'


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
  coffee:    './src/js/**/*.coffee'
  jade:      './src/html/*.jade'
  stylus:    './src/css/*.styl'

AppFile = [
  'header.coffee'
  'component-did-mount.coffee'
  'set-canvas-dimensions.coffee'
  'draw-toolbar0.coffee'
  'draw-toolbar1.coffee'
  'drawing-operations.coffee'
  'handle-mouse-down-workarea.coffee'
  'handle-click-toolbar0.coffee'
  'handle-click-toolbar1.coffee'
  'handle-save-and-save-as.coffee'
  'handle-open.coffee'
  'on-key-up-and-key-down.coffee'
  'render.coffee'
]

AppFile = _.map AppFile, (file) ->
  './src/js/App/' + file

resources = './resources'

gulp.task 'coffee', ->

  gulp.src AppFile
  .pipe concatenate 'index.coffee'
  .pipe gulp.dest './src/js'

  gulp.src './src/js/*.coffee'
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




