# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText} = require './drawingUtilities.coffee'


module.exports = (currentSheet, ctx, glyphs, color, cell, Assets) ->

  _.forEach currentSheet, (column, columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 5
    yCor =  5

    xOffset = (cell.w - 1) // 2

    ctx.drawImage Assets['X'][0], 
      xCor + xOffset + 5
      yCor

    ctx.drawImage Assets['<+'][0],
      xCor + 1
      yCor


  xCor = (currentSheet.length * (cell.w - 1)) + (cell.w * 2) + 5
  yCor =  5

  ctx.drawImage Assets['<+'][0],
    xCor + 1
    yCor
