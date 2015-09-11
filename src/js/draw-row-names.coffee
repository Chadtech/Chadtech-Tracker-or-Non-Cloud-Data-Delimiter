# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell) ->

  _.forEach sheet[0], (row, rowIndex) ->

    xCor = cell.w
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2)
    
    textXOffset = (cell.w - (11 * ('' + rowIndex).length)) // 2
    textXOffset -= 2

    drawABox ctx, color, cell, [ xCor, yCor ]
    drawText ctx, glyphs, 1, ('' + (rowIndex)), [ xCor + textXOffset, yCor + 4 ]