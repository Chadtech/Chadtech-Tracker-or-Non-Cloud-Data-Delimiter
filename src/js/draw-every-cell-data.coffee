# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'
{zeroPadder }                    = require './general-utilities.js'


module.exports = (sheet, ctx, glyphs, color, cell) ->

  corCalc = (index, dimension) ->
    (index * (dimension - 1)) + (dimension * 2) - 1

  _.forEach sheet, (column, columnIndex) ->
    _.forEach column, (datum, rowIndex) ->

      xCor = corCalc columnIndex, cell.w
      yCor = corCalc rowIndex, cell.h

      if datum.length
        drawText ctx, glyphs, 1, datum, [ xCor + 4, yCor + 3 ]
