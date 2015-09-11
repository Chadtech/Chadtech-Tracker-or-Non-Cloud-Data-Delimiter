# Libraries
_ = require 'lodash'

# Utilities
{drawText}    = require './drawingUtilities.js'
drawABox      = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell) ->

  _.forEach sheet, (column, columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2)
    yCor = cell.h
    
    textXOffset = (cell.w - (11 * ('' + columnIndex).length)) // 2
    textXOffset -= 2

    drawABox ctx, color, cell, [ xCor, yCor ]
    drawText ctx, glyphs, 1, ('' + (columnIndex)), [ xCor + textXOffset, yCor + 4 ]
