# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'
drawABox                         = require './draw-a-box.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet, (column, columnIndex) ->
    _.forEach column, (datum, datumIndex) ->

      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 5
      yCor = (datumIndex * (cell.h - 1)) + (cell.h * 2) + 5

      drawText ctx, glyphs, 1, datum, [ xCor + 3, yCor + 3 ]
      drawABox ctx, color, cell, [ xCor, yCor ]