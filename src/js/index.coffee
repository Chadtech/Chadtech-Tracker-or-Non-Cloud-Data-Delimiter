global.document   = window.document
global.navigator  = window.navigator


# Libraries
React = require 'react'
_     = require 'lodash'
gui   = require 'nw.gui'


# DOM Elements
{p, a, div, input, img, canvas} = React.DOM


# Utilities
{putPixel, hexToArray, drawText}                     = require './drawingUtilities.js'
CoordinateIsElement                                  = require './coordinate-in-array.js'
{convertToCSVs, zeroPadder, doNothing, Eightx15ify } = require './general-utilities.js'

# Dependencies
LoadGlyphs    = require './load-Glyphs.js'
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
DrawColumnNames     = require './draw-column-names.js'
DrawRowNames        = require './draw-row-names.js'
DrawEveryCell       = require './draw-every-cell.js'
DrawSelectedCell    = require './draw-selected-cell.js'
DrawColumnOptions   = require './draw-column-options.js'
DrawRowOptions      = require './draw-row-options.js'
DrawOriginMark      = require './draw-origin-mark.js'
DrawNormalCell      = require './draw-normal-cell.js'
DrawSheetTabs       = require './draw-sheet-tabs.js'
DrawEveryCellBorder = require './draw-every-cell-border.js'
DrawEveryCellData   = require './draw-every-cell-data.js'
ClearAllCellGlyphs  = require './clear-all-cell-glyphs.js'


# Colors
lighterGray = '#c0c0c0'
gray        = '#808080'
darkGray    = '#404040'
darkerGray  = '#202020'
borderGray  = '#101010'

cellColor     = hexToArray darkGray
edgeColor     = hexToArray darkerGray
selectedColor = hexToArray lighterGray
borderColor   = hexToArray borderGray


# Images for each character
Glyphs = undefined


# Dimensions
toolbarSize = 35
cell =
  w: 6 + (11 * 5)
  h: 7 + 19


# Assets
Assets = undefined 


buttonXBoundaries =
  'open': [ 5, 56 ]
  'save': [ 57, 109 ]


# Default Data for Development
currentSheet  = 0
sheetNames    = [ 'dollars', 'numbers' ]
Sheets        = require './initial-sheets.js'
selectedCells = [ [ 2, 3] ]
justSelected  = true
cellXOrg      = 0
cellYOrg      = 0
rowNameRadix  = 8



Index = React.createClass


  getInitialState: ->
    windowWidth:    window.innerWidth
    windowHeight:   window.innerHeight
    workareaHeight: window.innerHeight - (2 * toolbarSize)
    currentSheet:   0
    filePath:       ''


  componentDidMount: ->

    init = =>

      _.forEach [ 0 .. 4 ], ( CS ) ->
        thisScheme = Glyphs.images[ CS ]
        _.forEach (_.keys thisScheme), (key) ->
          character = thisScheme[ key ]

          glyphCanvas = document.createElement 'canvas'
          glyphCanvas.width   = 11
          glyphCanvas.height  = 19
          glyphCtx = glyphCanvas.getContext '2d'
          glyphCtx.drawImage character, 0, 0

          thisScheme[ key ] = glyphCanvas

        Glyphs.images[ CS ] = thisScheme

      gui.Window.get().on 'resize', @handleResize

      document.addEventListener 'keyup',   @onKeyUp
      document.addEventListener 'keydown', @onKeyDown

      @setCanvasDimensions()
      @drawToolBar0()
      @drawToolBar1()
      @refreshWorkArea()

      fileExporter = document.getElementById 'fileExporter'
      nwDir        = window.document.createAttribute 'nwdirectory'
      fileExporter.setAttributeNode nwDir

    next = =>
      Assets = AssetLoader init

    Glyphs                 = LoadGlyphs AllCharacters, next
    Glyphs.characterWidth  = 11
    Glyphs.characterHeight = 19


  setCanvasDimensions: ->
    toolbar0        = document.getElementById 'toolbar0'
    toolbar0.width  = window.innerWidth
    toolbar0.height = toolbarSize

    toolbar1        = document.getElementById 'toolbar1'
    toolbar1.width  = window.innerWidth
    toolbar1.height = toolbarSize

    workarea        = document.getElementById 'workarea'
    workarea.width  = window.innerWidth
    workarea.height = window.innerHeight - (2 * toolbarSize)


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

    toolbar0.drawImage Assets[ 'open' ][0], 5, 5
    toolbar0.drawImage Assets[ 'save' ][0], 58, 5


  drawToolBar1: ->
    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    for point in [ 0 .. window.innerWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar1, borderColor, [ point, 2 ]
      putPixel toolbar1, borderColor, [ point, 3 ]

    sheetXOrg = 5

    _.forEach Sheets, (sheet, sheetIndex) ->
      sheetName = sheetNames[ sheetIndex ]

      if sheetIndex isnt currentSheet

        tabWidth = sheetName.length + 2
        tabWidth *= Glyphs.characterWidth

        toolbar1.fillStyle = '#202020'
        toolbar1.fillRect sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1

        for point in [ 0 .. cell.h - 1 ]
          putPixel toolbar1, borderColor, [ sheetXOrg,                point + 3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg - 1,            point + 3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth,     point + 3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth - 1, point + 3 ]

        for point in [ 0 .. tabWidth + 1 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 3 ]

        glyphXOrg    = sheetXOrg
        glyphXOffset = tabWidth // 2
        glyphXOffset -= (11 * sheetName.length) // 2
        glyphXOrg    += glyphXOffset

        drawText toolbar1, Glyphs, 6, sheetName, [ glyphXOrg, 7 ]

        sheetXOrg += tabWidth + 5

      else

        tabWidth = sheetName.length + 2
        tabWidth *= Glyphs.characterWidth

        toolbar1.fillStyle = '#202020'
        toolbar1.fillRect sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1

        for point in [ 0 .. cell.h - 1 ]
          putPixel toolbar1, borderColor, [ sheetXOrg,                point + 3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg - 1,            point + 3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth,     point + 3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth - 1, point + 3 ]

        for point in [ 0 .. tabWidth + 1 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 3 ]

        glyphXOrg    = sheetXOrg
        glyphXOffset = tabWidth // 2
        glyphXOffset -= (11 * sheetName.length) // 2
        glyphXOrg    += glyphXOffset

        drawText toolbar1, Glyphs, 6, sheetName, [ glyphXOrg, 7 ]

        sheetXOrg += tabWidth + 5


  drawSelectedCellsNormal: ->
    workarea = document.getElementById 'workarea'
    workarea = workarea.getContext '2d'
    for selectedCell in selectedCells
      DrawNormalCell Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell, selectedCell      


  drawSelectedCellsSelected: ->
    workarea = document.getElementById 'workarea'
    workarea = workarea.getContext '2d'
    for selectedCell in selectedCells
      DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, selectedCell


  refreshWorkArea: ->
    workarea  = document.getElementById 'workarea'
    workarea  = workarea.getContext '2d', alpha: false
    sheetName = sheetNames[ @state.currentSheet ]

    workarea.fillStyle = '#000000'
    workarea.fillRect 0, 0, window.innerWidth, window.innerHeight

    just8x15        = Eightx15ify Sheets[ currentSheet ], cellXOrg, cellYOrg
    DrawOriginMark    sheetName, workarea, Glyphs, edgeColor, cell, Assets
    DrawColumnNames   just8x15,  workarea, Glyphs, edgeColor, cell, cellXOrg
    DrawRowNames      just8x15,  workarea, Glyphs, edgeColor, cell, cellYOrg

    ClearAllCellGlyphs  Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
    DrawEveryCellBorder Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
    DrawEveryCellData   Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell

    DrawColumnOptions Sheets[ currentSheet ], workarea, Glyphs, edgeColor, cell, Assets
    DrawRowOptions    Sheets[ currentSheet ], workarea, Glyphs, edgeColor, cell, Assets
    
    @drawSelectedCellsSelected()


  handleClickWorkArea: (event) ->
    mouseX = event.clientX
    mouseY = event.clientY
    mouseX -= cell.w
    mouseY -= cell.h
    mouseY -= toolbarSize + 5

    whichCell = [ 
      ((mouseY + 6) // cell.h) - 1
      (mouseX // cell.w) - 1
    ]
    
    workarea = document.getElementById 'workarea'
    workarea = workarea.getContext '2d', alpha: false

    if not event.metaKey
      if (whichCell[0] < 0) or (whichCell[1] < 0)

        # If they clicked the column name
        if whichCell[0] is -1
          thisColumn = Sheets[ currentSheet ][ whichCell[1] ]
          @drawSelectedCellsNormal()
          selectedCells = []
          _.forEach thisColumn, (row, rowIndex) ->
            selectedCells.push [ rowIndex, whichCell[1] ]
          @drawSelectedCellsSelected()

        # If they clicked either delete column or new column
        if whichCell[0] is -2
          # Delete column
          if (mouseX % cell.w) < 25
            Sheets[currentSheet].splice whichCell[1], 1
            ClearAllCellGlyphs  Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
            DrawEveryCellData   Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
          # add column
          else
            newColumn = []
            _.forEach Sheets[currentSheet][0], (column) ->
              newColumn.push ''
            Sheets[currentSheet].splice whichCell[1] + 1, 0, newColumn
            ClearAllCellGlyphs  Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
            DrawEveryCellData   Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
          @drawSelectedCellsNormal()
          selectedCells = []

        # If they clicked on the row name
        if whichCell[1] is -1
          @drawSelectedCellsNormal()
          selectedCells = []
          _.forEach Sheets[ currentSheet ], (column, columnIndex) ->
            selectedCells.push [ whichCell[0], columnIndex]
          @drawSelectedCellsSelected()

        # If they clicked on delete row or new row
        if whichCell[1] is -2
          # delete row
          if ((mouseX + cell.w) % cell.w) < 25
            _.forEach Sheets[currentSheet], (column) ->
              column.splice whichCell[0], 1         
            ClearAllCellGlyphs  Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
            DrawEveryCellData   Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
          # add row
          else
            _.forEach Sheets[currentSheet], (column) ->
              column.splice whichCell[0] + 1, 0, ''
            ClearAllCellGlyphs  Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
            DrawEveryCellData   Sheets[ currentSheet ], workarea, Glyphs, cellColor, cell
          @drawSelectedCellsNormal()
          selectedCells = []


      else
        @drawSelectedCellsNormal()   
        selectedCells = [ whichCell ]
        @drawSelectedCellsSelected()
        justSelected = true

    else
      unless CoordinateIsElement selectedCells, whichCell
        selectedCells.push whichCell
        DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, whichCell


  buttonFunctions:
    open: doNothing
    save: 
      mouseDown: (toolbar0) =>
        toolbar0.drawImage Assets['save'][1], 57, 5

      mouseUp: (toolbar0, handleSave, handleSaveAs, stateFilePath) =>
        if stateFilePath isnt ''
          handleSave()
        else
          @handleSaveAs()
        toolbar0.drawImage Assets['save'][0], 57, 5


  handleClickToolbar0: ->
    mouseX = event.clientX
    mouseY = event.clientY
    
    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d', alpha: false

    buttonXBoundaries =
      'open': [ 5, 56 ]
      'save': [ 57, 109 ]

    _.forEach (_.keys buttonXBoundaries), (key) =>
      button = buttonXBoundaries[ key ]
      if (mouseX > button[0]) and (button[1] > mouseX)
        @buttonFunctions[key].mouseDown toolbar0


  handleMouseUpToolbar0: ->
    mouseX = event.clientX
    mouseY = event.clientY
    
    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d', alpha: false

    buttonXBoundaries =
      'open': [ 5, 56 ]
      'save': [ 57, 109 ]

    _.forEach (_.keys buttonXBoundaries), (key) =>
      button = buttonXBoundaries[ key ]
      if (mouseX > button[0]) and (button[1] > mouseX)
        @buttonFunctions[key].mouseUp toolbar0, 
          @handleSave
          @handleSaveAs
          @state.filePath


  handleSaveAs: ->
    csvs = convertToCSVs Sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    fileExporter = document.getElementById 'fileExporter'

    fileExporter.addEventListener 'change', (event) =>
      @setState filePath: event.target.value
      _.forEach csvs, (csv, csvIndex) =>
        filePath = event.target.value
        fileName = '/' + sheetNames[ csvIndex ]
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
      fileName = '/' + sheetNames[ csvIndex ]
      fileName += '.csv'
      filePath += fileName
      fs.writeFileSync filePath, csv


  onKeyUp: (event) ->
    # if event.which is Keys['command']
    #   @setState commandIsDown: false, ->
    #     console.log 'command is marked Up'

  onKeyDown: (event) ->

    workarea  = document.getElementById 'workarea'
    workarea  = workarea.getContext '2d', alpha: false   
    
    if event.metaKey

      if event.which is Keys['s']
        if @state.filePath
          @handleSave()
        else 
          @handleSaveAs()

    else
      
      if selectedCells.length is 1

        switch event.which

          when Keys['backspace']
            if justSelected
              justSelected = false
              SC = selectedCells[0]
              Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = ''
              DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, SC
            else
              SC = selectedCells[0]
              Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = ''
              DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, SC

          when Keys['enter']
            justSelected = true
            @drawSelectedCellsNormal()
            selectedCells[0][0]++
            @drawSelectedCellsSelected()

          when Keys['down']
            if selectedCells[0][0] < (Sheets[currentSheet][0].length - 1)
              justSelected = true
              @drawSelectedCellsNormal()
              if ((selectedCells[0][0] - cellYOrg ) % 14) is 13
                cellYOrg++
              selectedCells[0][0]++
              @drawSelectedCellsSelected()
          
          when Keys['up']
            justSelected = true
            @drawSelectedCellsNormal()
            selectedCells[0][0]--
            @drawSelectedCellsSelected()

          when Keys['right']
            justSelected = true
            @drawSelectedCellsNormal()
            selectedCells[0][1]++
            @drawSelectedCellsSelected()
          
          when Keys['left']
            justSelected = true
            @drawSelectedCellsNormal()
            selectedCells[0][1]--
            @drawSelectedCellsSelected()

          when Keys['ctrl']  then doNothing()
          when Keys['shift'] then doNothing()
          when Keys['alt']   then doNothing()

          else
            if event.shiftKey

              if justSelected
                justSelected = false
                SC = selectedCells[0]
                Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = Keys[ event.which ].toUpperCase()
                DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, SC
              else
                SC = selectedCells[0]
                Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] += Keys[ event.which ].toUpperCase()
                DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, SC

            else

              if justSelected
                justSelected = false
                SC = selectedCells[0]
                Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = Keys[ event.which ]
                DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, SC
              else
                SC = selectedCells[0]
                Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] += Keys[ event.which ]
                DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, SC
              


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
        onMouseDown:        @handleClickToolbar0
        onMouseUp:          @handleMouseUpToolbar0
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


