# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell, cellYOrg, radix) ->

  _.forEach [ 0 .. 14 ], (rowIndex) ->

    xCor = cell.w
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 3
    
    rowName = (rowIndex + cellYOrg).toString radix

    textXOffset = (cell.w - (11 * rowName.length)) // 2
    textXOffset -= 2

    ctx.fillStyle = '#000000'
    ctx.fillRect xCor + 2, yCor + 2, cell.w - 3, cell.h - 3

    drawText ctx, glyphs, 1, rowName, [ xCor + textXOffset, yCor + 4 ]