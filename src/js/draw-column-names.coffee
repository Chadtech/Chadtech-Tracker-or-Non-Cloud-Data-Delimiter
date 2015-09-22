# Libraries
_ = require 'lodash'

# Utilities
{drawText}    = require './drawingUtilities.js'
drawABox      = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell, cellXOrg) ->

  _.forEach [ 0 .. 7 ], (columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) - 1
    yCor = cell.h - 2
    
    columnName = '' + (columnIndex + cellXOrg)

    textXOffset = (cell.w - (11 * columnName.length)) // 2
    textXOffset -= 2

    drawText ctx, glyphs, 1, columnName, [ xCor + textXOffset, yCor + 4 ]
