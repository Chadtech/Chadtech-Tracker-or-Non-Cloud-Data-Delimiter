# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'
drawABox                         = require './draw-a-box.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet[0], (row, rowIndex) ->

    xCor = 0
    yCor = (rowIndex * (cell.h - 1)) + cell.h

    drawText ctx, glyphs, 1, ('' + (rowIndex)), [ xCor + 3, yCor + 3 ]
    drawABox ctx, color, cell, [ xCor, yCor ]