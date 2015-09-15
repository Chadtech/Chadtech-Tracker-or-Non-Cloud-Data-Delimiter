# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText, drawABox} = require './drawingUtilities.js'
drawABox                                   = require './draw-a-box.js'

module.exports = (sheet, ctx, glyphs, color, cell, pos) ->

  corCalc = (index, dimension) ->
    (index * (dimension - 1)) + (dimension * 2) - 1

  xCor = corCalc pos[1], cell.w
  yCor = corCalc pos[0], cell.h

  datum = sheet[ pos[1] ][ pos[0] ]

  drawABox ctx, color, cell, [ xCor, yCor ]
  drawText ctx, glyphs, 1, datum, [ xCor + 4, yCor + 5 ]
