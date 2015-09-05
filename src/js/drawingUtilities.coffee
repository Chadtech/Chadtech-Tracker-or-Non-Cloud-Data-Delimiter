_ = require 'lodash'

module.exports =

  putPixel: (canvas, color, pos) ->
    newPixel          = canvas.createImageData 1, 1
    newPixelsColor    = newPixel.data
    newPixelsColor[0] = color[0]
    newPixelsColor[1] = color[1]
    newPixelsColor[2] = color[2]
    newPixelsColor[3] = 255
    canvas.putImageData newPixel, pos[0], pos[1]

  hexToArray: (color) ->
    colorArray = []
    colorArray.push color.slice 1, 3
    colorArray.push color.slice 3, 5
    colorArray.push color.slice 5, 7

    colorArray = _.map colorArray, (colorValue) ->
      parseInt colorValue, 16

    colorArray.push 255
    colorArray


  drawText: (canvas, glyphs, CS, text, pos) ->
    # CS stands for 'Color Scheme'
    _.forEach text, (character, characterIndex) ->
      xCor = pos[0]
      yCor = pos[1]
      xCor += characterIndex * glyphs.characterWidth
      canvas.drawImage glyphs.images[ CS ][ character ], xCor, yCor


