# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText} = require './drawingUtilities.js'


module.exports = (sheet, ctx, glyphs, color, cell, Assets) ->

  yCalc = (index) =>
    (index * (cell.h - 1) + (cell.h * 2)) + 1
  xCor = 0

  _.forEach [ 0 .. 14 ], (rowIndex) ->

    yCor = yCalc rowIndex

    ctx.drawImage Assets['X'][0],  xCor + 35, yCor
    ctx.drawImage Assets['^+'][0], xCor,      yCor

