# Libraries
_ = require 'lodash'

# Utilities
{putPixel} = require './drawingUtilities.js'

module.exports = (ctx, color, cell, pos) ->

  xOrg = pos[0]
  yOrg = pos[1]

  _.forEach [ 0 .. cell.w - 1 ], (pt) ->
    xCor = xOrg + pt
    putPixel ctx, color, [ xCor, yOrg + cell.h - 1 ]
    putPixel ctx, color, [ xCor, yOrg ]

  _.forEach [ 0 .. cell.h - 1 ], (pt) ->
    yCor  = yOrg + pt
    putPixel ctx, color, [ xOrg + cell.w - 1, yCor ]
    putPixel ctx, color, [ xOrg, yCor ]