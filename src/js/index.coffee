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
{convertToCSVs, zeroPadder }     = require './general-utilities.js'

# Dependencies
LoadGlyphs    = require './load-glyphs.js'
AssetLoader   = require './load-assets.js'
AllCharacters = require './all-characters.js'
Keys          = ((Keys) -> 

  output = {}
  _.forEach (_.keys Keys), (key) ->
    output[ Keys[ key ]] = key
  _.forEach (_.keys Keys), (key) ->
    output[ key ] = Keys[ key ] 
  output

  ) require './keys.js'


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


# Default Data for Development
currentSheet = 0
Sheets = [[ 
          [ '34', '32', '31', '32', '34', '34', '32', '31', '32', '34' ] 
          [ '32', '30', '31', '30', '32', '32', '30', '31', '30', '32' ] 
          [ 'B',  '',   'S',  'S',  '', 'B',  '',   'S',  'S',  ''   ] 
          [ 'Loud',  '', 'Quiet',  '',  '', 'Loud',  '', 'Quiet',  '',  ''   ] 
          [ '34', '32', '31', '32', '34', '34', '32', '31', '32', '34' ] 
          [ '32', '30', '31', '30', '32', '32', '30', '31', '30', '32' ] 
          [ 'B',  '',   'S',  'S',  '', 'B',  '',   'S',  'S',  ''   ] 
          [ 'Loud',  '', 'Quiet',  '',  '' , 'Loud',  '', 'Quiet',  '',  ''   ] 
        ]]




Index = React.createClass


  getInitialState: ->
    windowWidth:    window.innerWidth
    windowHeight:   window.innerHeight
    workareaHeight: window.innerHeight - (2 * toolbarSize)
    sheetNames:     [ 'dollars' ]
    selectedCells:  [ [ 2, 1 ] ]
    currentSheet:   0
    rowNameRadix:   8
    filePath:       ''
    justSelected:   true


  componentDidMount: ->
    gui.Window.get().on 'resize', @handleResize

    document.addEventListener 'keyup',   @onKeyUp
    document.addEventListener 'keydown', @onKeyDown

    @setCanvasDimensions()
    @drawToolBar0()
    @drawToolBar1()
    setTimeout @refreshWorkArea, 5000

    fileExporter = document.getElementById 'fileExporter'
    nwDir        = window.document.createAttribute 'nwdirectory'
    fileExporter.setAttributeNode nwDir

    # @setState a: ''
    # @setState a: ''
    # @setState a: ''


    # dataToPutInState = []

    # _.forEach Sheets, (sheet, sheetIndex) =>
    #   stateSetter = @setState

    #   columnSizeObject = {}
    #   columnSizeObject[ 'columnSize' + zeroPadder 2, sheetIndex ] = sheet.length
    #   @setState columnSizeObject

    #   rowSizeObject = {}
    #   rowSizeObject[ 'rowSize' + zeroPadder 2, sheetIndex ] = sheet[0].length
    #   @setState rowSizeObject

    #   _.forEach sheet, (column, columnIndex) =>
    #     _.forEach column, (row, rowIndex) =>
    #       dataKey  = 's' + zeroPadder 2, sheetIndex
    #       dataKey += 'c' + zeroPadder 3, columnIndex
    #       dataKey += 'r' + zeroPadder 3, rowIndex

    #       dataObject = ( 
    #         (a, b) -> 
    #           output = {}
    #           output[ b ] = a
    #           output
    #       )(row, dataKey)

    #       @setState dataObject


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

    # @refreshWorkArea()


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
    sheetName     = @state.sheetNames[ @state.currentSheet ]
    cellColor     = hexToArray darkGray
    edgeColor     = hexToArray darkerGray
    selectedColor = hexToArray lighterGray

    DrawOriginMark    sheetName,              workarea, glyphs, edgeColor, cell
    DrawColumnNames   Sheets[ currentSheet ], workarea, glyphs, edgeColor, cell
    DrawRowNames      Sheets[ currentSheet ], workarea, glyphs, edgeColor, cell
    DrawEveryCell     Sheets[ currentSheet ], workarea, glyphs, cellColor, cell
    DrawColumnOptions Sheets[ currentSheet ], workarea, glyphs, edgeColor, cell, Assets
    DrawRowOptions    Sheets[ currentSheet ], workarea, glyphs, edgeColor, cell, Assets
    for selectedCell in @state.selectedCells
      DrawSelectedCell Sheets[ currentSheet ], workarea, glyphs, selectedColor, cell, selectedCell


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

    if not event.metaKey
      unless (whichCell[0] < 0) or (whichCell[1] < 0)
        @setState selectedCells: [ whichCell ], =>
          @refreshWorkArea()
          @setState justSelected: true
    else
      unless CoordinateIsElement @state.selectedCells, whichCell
        @state.selectedCells.push whichCell
        @setState selectedCells: @state.selectedCells, =>
          @refreshWorkArea()


  handleSaveAs: ->
    csvs = convertToCSVs @state.sheets
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
    csvs = convertToCSVs @state.sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    _.forEach csvs, (csv, csvIndex) =>
      filePath = @state.filePath
      fileName = '/' + @state.sheetNames[ csvIndex ]
      fileName += '.csv'
      filePath += fileName
      fs.writeFileSync filePath, csv


  onKeyUp: (event) ->
    # if event.which is Keys['command']
    #   @setState commandIsDown: false, ->
    #     console.log 'command is marked Up'

  onKeyDown: (event) ->
    if event.metaKey

      if event.which is Keys['s']
        if @state.filePath
          @handleSave()
        else 
          @handleSaveAs()

    else
      
      if @state.selectedCells.length is 1

        if @state.justSelected
          @setState justSelected: false, =>
            # currentSheet  = @state.sheets[ @state.currentSheet ]
            # SC            = @state.selectedCells[0]
            # currentSheet[ SC[ 1 ] ][ SC[ 0 ] ] = Keys[ event.which ]
            # @state.sheets[ @state.currentSheet ] = currentSheet
            # datum = {}
            # datum[ 's' + (zeroPadder 2, @state.currentSheet) + 'c' + (zeroPadder 3, @state.selectedCells[0][1]) + 'r' + (zeroPadder 3, @state.selectedCells[0][0] )] = Keys[event.which]
            # console.log datum
            # @setState datum, =>
            #   @refreshWorkArea()
        # else
        #   @setState justSelected: false, =>
        #     currentSheet  = @state.sheets[ @state.currentSheet ]
        #     SC            = @state.selectedCells[0]
        #     currentSheet[ SC[ 1 ] ][ SC[ 0 ] ] += Keys[ event.which ]
        #     @state.sheets[ @state.currentSheet ] = currentSheet
        #     @setState sheets: @state.sheets, =>
        #       @refreshWorkArea()


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


