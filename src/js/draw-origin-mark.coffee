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
    h: cell.h * 2
    w: cell.w * 2

  ctx.fillStyle = '#202020'
  ctx.fillRect xCor, yCor, cell.w * 2, cell.h * 2

  ctx.drawImage Assets['^+'][0], cell.h, yCor + cell.h + 1
  ctx.drawImage Assets['<+'][0], xCor + 25 + cell.w, 0

  ctx.fillStyle = '#000000'
  ctx.fillRect cell.w + 2, cell.h + 2, (cell.w * 2) - 2, (cell.h * 2) - 2 