# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText} = require './drawingUtilities.js'


module.exports = (currentSheet, ctx, glyphs, color, cell, Assets) ->

  _.forEach currentSheet[0], (row, rowIndex) ->

    xCor = 8
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) + 8


    ctx.drawImage Assets['X'][0], xCor + 35, yCor

    ctx.drawImage Assets['^+'][0], xCor, yCor


  xCor = 8
  yCor = (currentSheet[0].length * (cell.h - 1)) + (cell.h * 2) + 8

  ctx.drawImage Assets['^+'][0], xCor, yCor
