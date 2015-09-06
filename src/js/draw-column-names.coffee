# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'
drawABox                         = require './draw-a-box.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet, (column, columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + cell.w
    yCor = 0

    drawText ctx, glyphs, 1, ('' + (columnIndex)), [ xCor + 3, yCor + 3 ]
    drawABox ctx, color, cell, [ xCor, yCor ]