# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText} = require './drawingUtilities.js'


module.exports = (currentSheet, ctx, glyphs, color, cell, Assets) ->

  yCalc = (index) =>
    index * (cell.h - 1) + (cell.h * 2)
  xCor = 0

  _.forEach currentSheet[0], (row, rowIndex) ->

    yCor = yCalc rowIndex

    ctx.drawImage Assets['X'][0],  xCor + 35, yCor
    ctx.drawImage Assets['^+'][0], xCor,      yCor

  yCor = yCalc currentSheet[0].length
  ctx.drawImage Assets['^+'][0], xCor, yCor
