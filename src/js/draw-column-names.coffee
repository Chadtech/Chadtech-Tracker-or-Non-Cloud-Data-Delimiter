# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet, (column, columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 7
    yCor = cell.h + 7
    
    textXOffset = (cell.w - (11 * ('' + columnIndex).length)) // 2
    textXOffset -= 2

    drawText ctx, glyphs, 1, ('' + (columnIndex)), [ xCor + textXOffset, yCor + 4 ]
    drawABox ctx, color, cell, [ xCor, yCor ]