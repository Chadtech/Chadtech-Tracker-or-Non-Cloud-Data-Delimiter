
_ = require 'lodash'

module.exports = (allCharacters) ->

  image = ->
    document.createElement 'IMG'

  characters =
    images:
      0: {}
      1: {}
      2: {}
      3: {}
      4: {}
      # 5: {}
      # 6: {}

  _.forEach [ 0 .. 4 ], (CS) ->
    _.forEach allCharacters, (character, characterIndex) ->
      characters.images[ CS ][ character ] = image()

      fileName = '' + characterIndex
      while fileName.length < 3
        fileName = '0' + fileName

      fontName = './hfnssC' + CS
      fileName = fontName + '/' + fontName 
      fileName += '_' + fileName + '.png'
      characters.images[ CS ][ character ].src = fileName

  characters
