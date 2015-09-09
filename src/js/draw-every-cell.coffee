# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  corCalc = (index, dimension) ->
    (index * (dimension - 1)) + (dimension * 2)

  _.forEach currentSheet, (column, columnIndex) ->
    _.forEach column, (datum, datumIndex) ->

      xCor = corCalc columnIndex, cell.w
      yCor = corCalc datumIndex, cell.h

      drawABox ctx, color, cell, [ xCor, yCor ]
      drawText ctx, glyphs, 1, datum, [ xCor + 4, yCor + 5 ]
