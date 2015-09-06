# Libraries
React = require 'react'
_     = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'

# Dependencies
Init                   = require './init.coffee'
AllCharacters          = require './all-characters.coffee'

# Drawing
DrawColumnNames   = require './draw-column-names.coffee'
DrawRowNames      = require './draw-row-names.coffee'
DrawEveryCell     = require './draw-every-cell.coffee'
DrawSelectedCell  = require './draw-selected-cell.coffee'

# DOM Elements
{p, a, div, input, img, canvas} = React.DOM


lighterGray = '#c0c0c0'
gray        = '#808080'
darkGray    = '#404040'
darkerGray  = '#202020'
borderGray  = '#101408'


glyphs                  = Init AllCharacters
glyphs.characterWidth   = 11
glyphs.characterHeight  = 19


toolbarSize = 52
cell =
  w: 4 + (glyphs.characterWidth * 5)
  h: 6 + glyphs.characterHeight




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
    rowNameRadix: 8


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
    cellColor     = hexToArray darkGray
    selectedColor = hexToArray lighterGray

    DrawColumnNames  currentSheet, workarea, glyphs, cellColor, cell
    DrawRowNames     currentSheet, workarea, glyphs, cellColor, cell
    DrawEveryCell    currentSheet, workarea, glyphs, cellColor, cell
    DrawSelectedCell currentSheet, workarea, glyphs, selectedColor, cell, @state.selectedCell


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

    whichCell = [ mouseY // (cell.h - 1), mouseX // (cell.w - 1), ]

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


