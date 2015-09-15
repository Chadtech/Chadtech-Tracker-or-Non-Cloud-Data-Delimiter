# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell, cellYOrg) ->

  _.forEach [ 0 .. 15 ], (rowIndex) ->

    xCor = cell.w
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 1
    
    textXOffset = (cell.w - (11 * ('' + rowIndex).length)) // 2
    textXOffset -= 2

    rowName = '' + (rowIndex + cellYOrg)

    drawABox ctx, color, cell, [ xCor, yCor ]
    drawText ctx, glyphs, 1, rowName, [ xCor + textXOffset, yCor + 4 ]