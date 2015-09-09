# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText}  = require './drawingUtilities.js'
drawABox                                      = require './draw-a-box.js'


module.exports = (currentSheet, ctx, glyphs, color, cell, sheetName) ->

  xCor = 8
  yCor = 8

  bigBox = 
    h: cell.h * 2
    w: cell.w * 2

  xOffSet = (cell.w * 2 - (11 * sheetName.length)) // 2
  drawABox ctx, color, bigBox, [ xCor, yCor ]
  drawText ctx, glyphs, 1, sheetName, [ xCor + 4 + xOffSet, yCor + 16 ]

