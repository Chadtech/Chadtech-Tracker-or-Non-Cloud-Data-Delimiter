_ = require 'lodash'

module.exports =

  putPixel: (ctx, color, pos) ->
    newPixel          = ctx.createImageData 1, 1
    newPixelsColor    = newPixel.data
    newPixelsColor[0] = color[0]
    newPixelsColor[1] = color[1]
    newPixelsColor[2] = color[2]
    newPixelsColor[3] = 255
    ctx.putImageData newPixel, pos[0], pos[1]

  hexToArray: (color) ->
    colorArray = []
    colorArray.push color.slice 1, 3
    colorArray.push color.slice 3, 5
    colorArray.push color.slice 5, 7

    colorArray = _.map colorArray, (colorValue) ->
      parseInt colorValue, 16

    colorArray.push 255
    colorArray

  arrayToHex: (color) ->
    colorHex = '#'
    colorHex += color[0].toString 16
    colorHex += color[1].toString 16
    colorHex += color[2].toString 16

    colorHex

  drawText: (ctx, glyphs, CS, text, pos) ->
    _.forEach text, (character, characterIndex) ->
      xCor = pos[0]
      yCor = pos[1]
      xCor += characterIndex * glyphs.characterWidth
      ctx.drawImage glyphs.images[ CS ][ character ], xCor, yCor
