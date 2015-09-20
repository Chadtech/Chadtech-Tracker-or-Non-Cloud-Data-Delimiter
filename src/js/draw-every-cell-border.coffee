# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
{zeroPadder }                    = require './general-utilities.js'
drawABorder                      = require './draw-a-border.js'



module.exports = (sheet, ctx, glyphs, color, cell) ->

  corCalc = (index, dimension) ->
    (index * (dimension - 1)) + (dimension * 2) - 1

  _.forEach [ 0 .. 8 ], (columnIndex) ->
    _.forEach [ 0 .. 15 ], (rowIndex) ->

      xCor = corCalc columnIndex, cell.w
      yCor = (corCalc rowIndex, cell.h) - 2

      drawABorder ctx, color, cell, [ xCor, yCor ]
