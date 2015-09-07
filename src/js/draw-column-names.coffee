# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'
drawABox                         = require './draw-a-box.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet, (column, columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 5
    yCor = cell.h + 5

    drawText ctx, glyphs, 3, ('' + (columnIndex)), [ xCor + 3, yCor + 3 ]
    drawABox ctx, color, cell, [ xCor, yCor ]