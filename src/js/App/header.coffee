global.document   = window.document
global.navigator  = window.navigator


# Libraries
React = require 'react'
_     = require 'lodash'
gui   = require 'nw.gui'


# DOM Elements
{div, input, canvas} = React.DOM


# Utilities
{putPixel, hexToArray, drawText}                     = require './drawingUtilities.js'
CoordinateIsElement                                  = require './coordinate-in-array.js'
{convertToCSVs, zeroPadder, doNothing, Eightx15ify } = require './general-utilities.js'
WorkArea = (doc) ->
  WorkArea = doc.getElementById 'workarea'
  WorkArea = WorkArea.getContext '2d', alpha: false

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
DrawEveryCell       = require './draw-every-cell.js'
DrawSelectedCell    = require './draw-selected-cell.js'
DrawColumnOptions   = require './draw-column-options.js'
DrawColumnNames     = require './draw-column-names.js'
DrawColumnBoxes     = require './draw-column-boxes.js'
DrawRowOptions      = require './draw-row-options.js'
DrawRowNames        = require './draw-row-names.js'
DrawRowBoxes        = require './draw-row-boxes.js'
DrawOriginMark      = require './draw-origin-mark.js'
DrawNormalCell      = require './draw-normal-cell.js'
DrawSheetTabs       = require './draw-sheet-tabs.js'
DrawEveryCellBorder = require './draw-every-cell-border.js'
DrawEveryCellData   = require './draw-every-cell-data.js'
ClearAllCellGlyphs  = require './clear-all-cell-glyphs.js'


# Colors
lighterGray   = '#c0c0c0'
gray          = '#808080'
darkGray      = '#404040'
darkerGray    = '#202020'
borderGray    = '#101010'

cellColor     = hexToArray darkGray
edgeColor     = hexToArray darkerGray
selectedColor = hexToArray lighterGray
borderColor   = hexToArray borderGray
topEdgeColor  = hexToArray gray


# Images for each character
Glyphs = undefined


# Dimensions
toolbarSize = 35
cell =
  w: 6 + (11 * 5)
  h: 7 +  19


# Assets
Assets = undefined 


buttonXBoundaries =
  'open':   [ 4,   55  ]
  'save':   [ 56,  108 ]
  'radix':  [ 264, 287 ]


buttonFunctions = 
  open:
    down: (ctx) ->
      ctx.drawImage Assets['open'][1], buttonXBoundaries.open[0], 4
    up: (ctx, handleOpen) ->
      handleOpen()
      ctx.drawImage Assets['open'][0], buttonXBoundaries.open[0], 4

  save:
    down: (ctx) ->
      ctx.drawImage Assets['save'][1], buttonXBoundaries.save[0], 4
    up: (ctx, handleSave, handleSaveAs, saveFilePath)->
      if saveFilePath isnt ''
        handleSave()
      else
        handleSaveAs()
      ctx.drawImage Assets['save'][0], buttonXBoundaries.save[0], 4


# Main Globals
currentSheet  = 0
sheetNames    = [ ]
Sheets        = [ ]
selectedCells = [ [ 2, 3 ] ]
justSelected  = true
cellXOrg      = 0
cellYOrg      = 0
rowNameRadix  = 8
newSheetName  = 'newSheet'
sheetNameJustSelected = false
keyArea       = 'workarea'

