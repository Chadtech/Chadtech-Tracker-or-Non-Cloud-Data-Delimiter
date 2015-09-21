# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, drawText} = require './drawingUtilities.js'
drawABox                         = require './draw-a-box.js'

module.exports = (ctx, color, cell) ->

  _.forEach [ 0 .. 14 ], (rowIndex) ->

    xCor = cell.w
    yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 3
    
    drawABox ctx, color, cell, [ xCor, yCor ]
