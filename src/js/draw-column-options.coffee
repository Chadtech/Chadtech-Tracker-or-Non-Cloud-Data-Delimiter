# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText} = require './drawingUtilities.js'


module.exports = (sheet, ctx, glyphs, color, cell, Assets) ->

  xCalc = (index) =>
    index * (cell.w - 1) + (cell.w * 2)
  yCor = 0

  _.forEach [ 0 .. 8 ], (columnIndex) ->

    xCor = xCalc columnIndex

    ctx.drawImage Assets['X'][0],  xCor + 35, yCor
    ctx.drawImage Assets['<+'][0], xCor,      yCor

