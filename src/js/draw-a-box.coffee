# Utilities
drawABorder = require './draw-a-border.js'
fillASquare = require './fill-a-square.js'

module.exports = (ctx, color, cell, pos) ->

  fillASquare ctx, color, cell, pos
  drawABorder ctx, color, cell, pos
