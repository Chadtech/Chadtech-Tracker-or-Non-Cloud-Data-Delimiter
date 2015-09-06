# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell, pos) ->

  xCor = (pos[1] * (cell.w - 1)) + cell.w
  yCor = (pos[0] * (cell.h - 1)) + cell.h

  datum = currentSheet[ pos[1] ][ pos[0] ]
  drawText ctx, glyphs, 0, datum, [ xCor + 3, yCor + 3 ]

  _.forEach [ 0 .. cell.w - 1 ], (point) ->  
    thisXCor = xCor + point        
    putPixel ctx, color, [ thisXCor, yCor + cell.h - 1]
    putPixel ctx, color, [ thisXCor, yCor ]

  _.forEach [ 0 .. cell.h - 1 ], (point) ->
    thisYCor = yCor + point
    putPixel ctx, color, [ xCor + cell.w - 1, thisYCor ]
    putPixel ctx, color, [ xCor, thisYCor ]