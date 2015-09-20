# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex, drawText}  = require './drawingUtilities.js'
# drawABox                                      = require './draw-a-box.js'
fillASquare                      = require './fill-a-square.js'


module.exports = (sheetName, ctx, glyphs, color, cell, Assets) ->

  xCor = 0
  yCor = 0

  bigBox = 
    h: (cell.h * 2 ) - 2
    w: (cell.w * 2 ) - 1

  ctx.fillStyle = '#202020'
  ctx.fillRect xCor, yCor, bigBox.w, bigBox.h

  ctx.drawImage Assets['^+'][0], 25, yCor + cell.h - 1
  ctx.drawImage Assets['<+'][0], xCor + 26 + cell.w, 0

  ctx.fillStyle = '#000000'
  ctx.fillRect cell.w + 2, cell.h, (cell.w * 2) - 2, (cell.h * 2)