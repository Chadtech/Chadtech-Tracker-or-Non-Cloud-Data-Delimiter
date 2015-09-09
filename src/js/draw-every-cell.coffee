# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet, (column, columnIndex) ->
    _.forEach column, (datum, datumIndex) ->

      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 7
      yCor = (datumIndex * (cell.h - 1)) + (cell.h * 2) + 7

      drawText ctx, glyphs, 1, datum, [ xCor + 4, yCor + 5 ]
      drawABox ctx, color, cell, [ xCor, yCor ]