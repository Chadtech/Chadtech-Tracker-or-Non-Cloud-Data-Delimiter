# Libraries
React = require 'react'
_     = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'

# Dependencies
Init                   = require './init.coffee'
AllCharacters          = require './all-characters.coffee'

# titleImage = new Image()
# titleImage.src = './titleImage.png'

# DOM Elements
{p, a, div, input, img, canvas} = React.DOM


lighterGray = '#c0c0c0'
gray        = '#808080'
darkGray    = '#404040'
darkerGray  = '#202020'
borderGray  = '#101408'

wackyColorWOW = '#e64088'

characterWidth  = 11
characterHeight = 19

toolbarSize = 52
cellWidth   = 4 + (characterWidth * 5)
cellHeight  = 6 + characterHeight

glyphs                  = Init AllCharacters
glyphs.characterWidth   = characterWidth
glyphs.characterHeight  = characterHeight

Index = React.createClass


  getInitialState: ->
    windowWidth:    window.innerWidth
    windowHeight:   window.innerHeight
    workareaHeight: window.innerHeight - (2 * (toolbarSize + 5))
    sheets: [[ 
          [ '34', '32', '31', '32', '34'] 
          [ '32', '30', '31', '30', '32' ] 
          [ 'B', '', 'S', 'S', '' ] 
        ]]
    selectedCell: [ 2, 1 ]
    currentSheet: 0


  componentDidMount: ->
    window.addEventListener 'resize', @handleResize

    @setCanvasDimensions()
    @drawToolBar0()
    @drawToolBar1()
    setTimeout @refreshWorkArea, 3000



  setCanvasDimensions: ->
    toolbar0        = document.getElementById 'toolbar0'
    toolbar0.width  = window.innerWidth
    toolbar0.height = toolbarSize

    toolbar1        = document.getElementById 'toolbar1'
    toolbar1.width  = window.innerWidth
    toolbar1.height = toolbarSize

    workarea        = document.getElementById 'workarea'
    workarea.width  = window.innerWidth
    workarea.height = window.innerHeight - (2 * (toolbarSize + 5))


  handleResize: ->
    @setState windowWidth:  window.innerWidth, =>
      @setState windowHeight: window.innerHeight, =>

        @setCanvasDimensions
        @drawToolBar0()
        @drawToolBar1()


  drawToolBar0: ->
    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d'

    for point in [ 0 .. @state.windowWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar0, borderColor, [ point, toolbarSize - 1 ]

    # putTitle = =>
    #   toolbar0.drawImage titleImage, 5, 5
    # setTimeout putTitle, 2000


  drawToolBar1: ->
    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    for point in [ 0 .. @state.windowWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar1, borderColor, [ point, 0 ]


  refreshWorkArea: ->
    workarea = document.getElementById 'workarea'
    workarea = workarea.getContext '2d'

    currentSheet = @state.sheets[ @state.currentSheet ]

    # Drawing the column names
    _.forEach currentSheet, (column, columnIndex) ->

      cellColor = hexToArray darkGray
      xCor      = (columnIndex * (cellWidth - 1)) + cellWidth
      yCor      = 0
      # yCor      = (datumIndex * (cellHeight - 1)) + cellHeight

      drawText workarea, glyphs, 1, ('' + (columnIndex % 2)), [ xCor + 3, yCor + 3 ]
      
      _.forEach [ 0 .. cellWidth - 1 ], (point) ->  
        thisXCor = xCor + point        
        putPixel workarea, cellColor, [ thisXCor, yCor + cellHeight - 1]
        putPixel workarea, cellColor, [ thisXCor, yCor ]

      _.forEach [ 0 .. cellHeight - 1 ], (point) ->
        thisYCor = yCor + point
        putPixel workarea, cellColor, [ xCor + cellWidth - 1, thisYCor ]
        putPixel workarea, cellColor, [ xCor, thisYCor ]

    # Drawing every cell
    _.forEach currentSheet, (column, columnIndex) ->
      _.forEach column, (datum, datumIndex) ->

        cellColor = hexToArray darkGray
        xCor      = (columnIndex * (cellWidth - 1)) + cellWidth
        yCor      = (datumIndex * (cellHeight - 1)) + cellHeight

        drawText workarea, glyphs, 1, datum, [ xCor + 3, yCor + 3 ]
        
        _.forEach [ 0 .. cellWidth - 1 ], (point) ->  
          thisXCor = xCor + point        
          putPixel workarea, cellColor, [ thisXCor, yCor + cellHeight - 1]
          putPixel workarea, cellColor, [ thisXCor, yCor ]

        _.forEach [ 0 .. cellHeight - 1 ], (point) ->
          thisYCor = yCor + point
          putPixel workarea, cellColor, [ xCor + cellWidth - 1, thisYCor ]
          putPixel workarea, cellColor, [ xCor, thisYCor ]

    # Drawing the selected cell
    cellColor = hexToArray lighterGray
    xCor = (@state.selectedCell[1] * (cellWidth - 1)) + cellWidth
    yCor = (@state.selectedCell[0] * (cellHeight - 1)) + cellHeight

    datum = currentSheet[ @state.selectedCell[1] ][ @state.selectedCell[0] ]
    drawText workarea, glyphs, 0, datum, [ xCor + 3, yCor + 3 ]

    _.forEach [ 0 .. cellWidth - 1 ], (point) ->  
      thisXCor = xCor + point        
      putPixel workarea, cellColor, [ thisXCor, yCor + cellHeight - 1]
      putPixel workarea, cellColor, [ thisXCor, yCor ]

    _.forEach [ 0 .. cellHeight - 1 ], (point) ->
      thisYCor = yCor + point
      putPixel workarea, cellColor, [ xCor + cellWidth - 1, thisYCor ]
      putPixel workarea, cellColor, [ xCor, thisYCor ]

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
    mouseX -= cellWidth
    mouseY -= cellHeight
    mouseY -= toolbarSize + 5

    whichCell = [ mouseY // (cellHeight - 1), mouseX // (cellWidth - 1), ]

    console.log whichCell

    @setState selectedCell: whichCell, =>
      @refreshWorkArea()



  render: ->

    div
      style:
        backgroundColor:  darkerGray
        width:            '100%'
        height:           '100%'
        margin:           0
        padding:          0
        position:         'absolute'
        top:              0
        left:             0

      canvas
        id:               'toolbar0'
        style:
          backgroundColor: darkerGray
          width:           '100%'
          height:          toolbarSize
          imageRendering:  'pixelated'

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
          backgroundColor:  '#000000'
          position:         'absolute'
          top:              toolbarSize + 5
          left:             0
          width:            '100%'
          height:           @state.workareaHeight
          imageRendering:   'pixelated'




Index          = React.createElement Index
injectionPoint = document.getElementById 'content'
React.render Index, injectionPoint


