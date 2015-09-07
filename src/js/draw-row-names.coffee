# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet[0], (row, rowIndex) ->

    xCor = cell.w + 5
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) + 5
    
    textXOffset = (cell.w - (11 * ('' + rowIndex).length)) // 2
    textXOffset -= 2

    drawText ctx, glyphs, 1, ('' + (rowIndex)), [ xCor + textXOffset, yCor + 3 ]
    drawABox ctx, color, cell, [ xCor, yCor ]