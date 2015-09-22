# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (ctx, color, cell) ->

  _.forEach [ 0 .. 7 ], (columnIndex) ->

    xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) - 1
    yCor = cell.h - 2
    
    drawABox ctx, color, cell, [ xCor, yCor ]
