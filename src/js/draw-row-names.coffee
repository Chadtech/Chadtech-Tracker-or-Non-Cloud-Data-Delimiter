# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'
drawABox                         = require './draw-a-box.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet[0], (row, rowIndex) ->

    xCor = cell.w + 5
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) + 5

    drawText ctx, glyphs, 3, ('' + (rowIndex)), [ xCor + 3, yCor + 3 ]
    drawABox ctx, color, cell, [ xCor, yCor ]