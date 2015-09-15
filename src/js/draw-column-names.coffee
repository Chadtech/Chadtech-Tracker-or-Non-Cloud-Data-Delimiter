# Libraries
_ = require 'lodash'

# Utilities
{drawText}    = require './drawingUtilities.js'
drawABox      = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell, cellXOrg) ->

  _.forEach [ 0 .. 8 ], (columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) - 1
    yCor = cell.h
    
    textXOffset = (cell.w - (11 * ('' + columnIndex).length)) // 2
    textXOffset -= 2

    columnName = '' + (columnIndex + cellXOrg)

    drawABox ctx, color, cell, [ xCor, yCor ]
    drawText ctx, glyphs, 1, columnName, [ xCor + textXOffset, yCor + 4 ]
