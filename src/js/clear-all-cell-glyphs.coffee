# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
{zeroPadder }                    = require './general-utilities.js'
fillASquare                      = require './fill-a-square.js'


module.exports = (sheet, ctx, glyphs, color, cell) ->

  corCalc = (index, dimension) ->
    (index * (dimension - 1)) + (dimension * 2)

  _.forEach [ 0 .. 8 ], (columnIndex) ->
    _.forEach [ 0 .. 15 ], (rowIndex) ->

      xCor = corCalc columnIndex, cell.w
      yCor = corCalc rowIndex, cell.h

      fillASquare ctx, color, 
        {w: cell.w - 4, h: cell.h - 4}
        [ xCor + 2,   yCor + 2  ]