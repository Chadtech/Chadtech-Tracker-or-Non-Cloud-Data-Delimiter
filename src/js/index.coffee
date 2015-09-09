global.document   = window.document
global.navigator  = window.navigator


# Libraries
React    = require 'react'
_        = require 'lodash'
gui      = require 'nw.gui'


# DOM Elements
{p, a, div, input, img, canvas} = React.DOM


# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
CoordinateIsElement              = require './coordinate-in-array.js'
ConvertToCSV                     = require './convert-sheets-to-csvs.js'


# Dependencies
LoadGlyphs    = require './load-glyphs.js'
AssetLoader   = require './load-assets.js'
AllCharacters = require './all-characters.js'
Keys          = require './keys.js'


# Drawing
DrawColumnNames   = require './draw-column-names.js'
DrawRowNames      = require './draw-row-names.js'
DrawEveryCell     = require './draw-every-cell.js'
DrawSelectedCell  = require './draw-selected-cell.js'
DrawColumnOptions = require './draw-column-options.js'
DrawRowOptions    = require './draw-row-options.js'
DrawOriginMark    = require './draw-origin-mark.js'


# Colors
lighterGray = '#c0c0c0'
gray        = '#808080'
darkGray    = '#404040'
darkerGray  = '#202020'
borderGray  = '#101408'


# Images for each character
glyphs                  = LoadGlyphs AllCharacters
glyphs.characterWidth   = 11
glyphs.characterHeight  = 19


# Dimensions
toolbarSize = 52
cell =
  w: 6 + (glyphs.characterWidth * 5)
  h: 7 + glyphs.characterHeight


# Assets
Assets = AssetLoader()


Index = React.createClass


  getInitialState: ->
    windowWidth:    window.innerWidth
    windowHeight:   window.innerHeight
    workareaHeight: window.innerHeight - (2 * toolbarSize)
    sheets: [[ 
          [ '34', '32', '31', '32', '34', '34', '32', '31', '32', '34' ] 
          [ '32', '30', '31', '30', '32', '32', '30', '31', '30', '32' ] 
          [ 'B',  '',   'S',  'S',  '', 'B',  '',   'S',  'S',  ''   ] 
          [ 'Loud',  '', 'Quiet',  '',  '', 'Loud',  '', 'Quiet',  '',  ''   ] 
          [ '34', '32', '31', '32', '34', '34', '32', '31', '32', '34' ] 
          [ '32', '30', '31', '30', '32', '32', '30', '31', '30', '32' ] 
          [ 'B',  '',   'S',  'S',  '', 'B',  '',   'S',  'S',  ''   ] 
          [ 'Loud',  '', 'Quiet',  '',  '' , 'Loud',  '', 'Quiet',  '',  ''   ] 
        ]]
    sheetNames: [ 'dollars' ]
    selectedCells: [ [ 2, 1 ] ]
    currentSheet:  0
    rowNameRadix:  8
    commandIsDown: false
    filePath:      ''


  componentDidMount: ->
    gui.Window.get().on 'resize', @handleResize

    document.addEventListener 'keyup',   @onKeyUp
    document.addEventListener 'keydown', @onKeyDown

    @setCanvasDimensions()
    @drawToolBar0()
    @drawToolBar1()
    setTimeout @refreshWorkArea, 3000

    fileExporter = document.getElementById 'fileExporter'
    nwDir        = window.document.createAttribute 'nwdirectory'
    fileExporter.setAttributeNode nwDir


  setCanvasDimensions: ->
    toolbar0        = document.getElementById 'toolbar0'
    toolbar0.width  = @state.windowWidth
    toolbar0.height = toolbarSize

    toolbar1        = document.getElementById 'toolbar1'
    toolbar1.width  = @state.windowHeight
    toolbar1.height = toolbarSize

    workarea        = document.getElementById 'workarea'
    workarea.width  = @state.windowWidth
    workarea.height = @state.windowHeight - (2 * (toolbarSize + 5))

    @refreshWorkArea()


  handleResize: ->
    @setState windowWidth:  window.innerWidth, =>
      @setState windowHeight: window.innerHeight, =>

        @setCanvasDimensions()
        @drawToolBar0()
        @drawToolBar1()


  drawToolBar0: ->
    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d'

    for point in [ 0 .. @state.windowWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar0, borderColor, [ point, toolbarSize - 1 ]


  drawToolBar1: ->
    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    for point in [ 0 .. @state.windowWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar1, borderColor, [ point, 0 ]


  refreshWorkArea: ->
    workarea      = document.getElementById 'workarea'
    workarea      = workarea.getContext '2d'
    currentSheet  = @state.sheets[ @state.currentSheet ]
    sheetName     = @state.sheetNames[ @state.currentSheet ]
    cellColor     = hexToArray darkGray
    edgeColor     = hexToArray darkerGray
    selectedColor = hexToArray lighterGray

    DrawOriginMark    currentSheet, workarea, glyphs, edgeColor, cell, sheetName
    DrawColumnNames   currentSheet, workarea, glyphs, edgeColor, cell
    DrawRowNames      currentSheet, workarea, glyphs, edgeColor, cell
    DrawEveryCell     currentSheet, workarea, glyphs, cellColor, cell
    DrawColumnOptions currentSheet, workarea, glyphs, edgeColor, cell, Assets
    DrawRowOptions    currentSheet, workarea, glyphs, edgeColor, cell, Assets
    for selectedCell in @state.selectedCells
      DrawSelectedCell currentSheet, workarea, glyphs, selectedColor, cell, selectedCell


    # # pastin = =>
    # middleX = 400
    # middleY = 100
    # messages = [
    #   'Chadtech Tracker or Non-Cloud Data Delimiter'
    # ]

    # # for messageIndex in [ 0 .. messages.length - 1 ]
    # #   message = messages[ messageIndex ]
    # drawText workarea, glyphs, 2, messages[0], [ middleX, middleY ]

    # setTimeout pastin, 3000

  handleClickWorkArea: (event) ->
    mouseX = event.clientX
    mouseY = event.clientY
    mouseX -= cell.w
    mouseY -= cell.h
    mouseY -= toolbarSize + 5

    whichCell = [ 
      (mouseY // cell.h) - 1
      (mouseX // cell.w) - 1
    ]

    if not @state.commandIsDown
      unless (whichCell[0] < 0) or (whichCell[1] < 0)
        @setState selectedCells: [ whichCell ], =>
          @refreshWorkArea()
    else
      unless CoordinateIsElement @state.selectedCells, whichCell
        @state.selectedCells.push whichCell
        @setState selectedCells: @state.selectedCells, =>
          @refreshWorkArea()


  handleSaveAs: ->
    csvs = ConvertToCSV @state.sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    fileExporter = document.getElementById 'fileExporter'

    fileExporter.addEventListener 'change', (event) =>
      @setState filePath: event.target.value
      _.forEach csvs, (csv, csvIndex) =>
        filePath = event.target.value
        fileName = '/' + @state.sheetNames[ csvIndex ]
        fileName += '.csv'
        filePath += fileName
        fs.writeFileSync filePath, csv
        

    fileExporter.click()

  handleSave: ->
    csvs = ConvertToCSV @state.sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    _.forEach csvs, (csv, csvIndex) =>
      filePath = @state.filePath
      fileName = '/' + @state.sheetNames[ csvIndex ]
      fileName += '.csv'
      filePath += fileName
      fs.writeFileSync filePath, csv


  onKeyUp: (event) ->
    if event.which is Keys['command']
      @setState commandIsDown: false, ->
        console.log 'command is marked Up'

  onKeyDown: (event) ->
    if event.which is Keys['command']
      @setState commandIsDown: true, ->
        console.log 'command is marked down'

    if event.which is Keys['s']
      if @state.filePath
        @handleSave()
      else 
        @handleSaveAs()
      


  render: ->

    div
      style:
        backgroundColor:    darkerGray
        width:              '100%'
        height:             '100%'
        margin:             0
        padding:            0
        position:           'absolute'
        top:                0
        left:               0

      canvas
        id:                 'toolbar0'
        style:
          backgroundColor:  darkerGray
          width:            '100%'
          height:           toolbarSize
          imageRendering:   'pixelated'

      canvas
        id:                 'toolbar1'
        style:
          backgroundColor:  darkerGray
          position:         'absolute'
          top:              @state.windowHeight - toolbarSize
          left:             0
          width:            '100%'
          height:           toolbarSize
          imageRendering:   'pixelated'

      canvas
        id:                 'workarea'
        onMouseDown:        @handleClickWorkArea
        style:
          backgroundColor:  darkerGray
          position:         'absolute'
          top:              toolbarSize
          left:             0
          width:            '100%'
          height:           @state.workareaHeight
          imageRendering:   'pixelated'



Index          = React.createElement Index
injectionPoint = document.getElementById 'content'
React.render Index, injectionPoint


