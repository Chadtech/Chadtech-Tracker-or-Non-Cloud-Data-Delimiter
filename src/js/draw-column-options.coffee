# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText} = require './drawingUtilities.js'


module.exports = (currentSheet, ctx, glyphs, color, cell, Assets) ->

  _.forEach currentSheet, (column, columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 8
    yCor = 8

    ctx.drawImage Assets['X'][0], xCor + 35, yCor
    ctx.drawImage Assets['<+'][0], xCor, yCor


  xCor = (currentSheet.length * (cell.w - 1)) + (cell.w * 2) + 8
  yCor =  8

  ctx.drawImage Assets['<+'][0], xCor, yCor
