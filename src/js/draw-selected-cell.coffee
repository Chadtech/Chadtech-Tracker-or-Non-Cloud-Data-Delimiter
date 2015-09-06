# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText, drawABox} = require './drawingUtilities.coffee'
drawABox                                   = require './draw-a-box.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell, pos) ->

  xCor = (pos[1] * (cell.w - 1)) + cell.w
  yCor = (pos[0] * (cell.h - 1)) + cell.h

  datum = currentSheet[ pos[1] ][ pos[0] ]

  drawText ctx, glyphs, 0, datum, [ xCor + 3, yCor + 3 ]
  drawABox ctx, color, cell, [ xCor, yCor ]
