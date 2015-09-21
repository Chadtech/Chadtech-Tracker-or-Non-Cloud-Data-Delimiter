# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell, cellYOrg) ->

  _.forEach [ 0 .. 14 ], (rowIndex) ->

    xCor = cell.w
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 3
    
    rowName = '' + (rowIndex + cellYOrg)

    textXOffset = (cell.w - (11 * rowName.length)) // 2
    textXOffset -= 2

    drawText ctx, glyphs, 1, rowName, [ xCor + textXOffset, yCor + 4 ]