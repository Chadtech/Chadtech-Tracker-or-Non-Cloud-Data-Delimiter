# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.coffee'

module.exports = (currentSheet, ctx, glyphs, color, cell) ->

  _.forEach currentSheet, (column, columnIndex) ->
    _.forEach column, (datum, datumIndex) ->

      xCor = (columnIndex * (cell.w - 1)) + cell.w
      yCor = (datumIndex * (cell.h - 1)) + cell.h

      drawText ctx, glyphs, 1, datum, [ xCor + 3, yCor + 3 ]
    
      _.forEach [ 0 .. cell.w - 1 ], (point) ->  
        thisXCor = xCor + point        
        putPixel ctx, color, [ thisXCor, yCor + cell.h - 1]
        putPixel ctx, color, [ thisXCor, yCor ]

      _.forEach [ 0 .. cell.h - 1 ], (point) ->
        thisYCor = yCor + point
        putPixel ctx, color, [ xCor + cell.w - 1, thisYCor ]
        putPixel ctx, color, [ xCor, thisYCor ]