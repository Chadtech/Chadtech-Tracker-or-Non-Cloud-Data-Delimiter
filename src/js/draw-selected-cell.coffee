# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText, drawABox} = require './drawingUtilities.js'
drawABox                                   = require './draw-a-box.js'

module.exports = (currentSheet, ctx, glyphs, color, cell, pos) ->

  xCor = (pos[1] * (cell.w - 1)) + (cell.w * 2) + 7
  yCor = (pos[0] * (cell.h - 1)) + (cell.h * 2) + 7

  datum = currentSheet[ pos[1] ][ pos[0] ]

  drawText ctx, glyphs, 0, datum, [ xCor + 4, yCor + 4 ]
  drawABox ctx, color, cell, [ xCor, yCor ]
