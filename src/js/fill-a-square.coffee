# Libraries
_ = require 'lodash'

# Utilities
{putPixel, hexToArray, arrayToHex} = require './drawingUtilities.js'

module.exports = (ctx, color, cell, pos) ->

  xOrg = pos[0]
  yOrg = pos[1]

  ctx.fillStyle = '#000000'
  ctx.fillRect xOrg, yOrg, cell.w, cell.h
