
_ = require 'lodash'

module.exports = (allCharacters) ->

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
      # characters.images[ CS ][ character] = new Image()
      characters.images[ CS ][ character ] = document.createElement 'IMG'

      fileName = '' + characterIndex
      while fileName.length < 3
        fileName = '0' + fileName

      fileName = './hfnssC' + CS + '/hfnssC' + CS + '_' + fileName + '.png'
      characters.images[ CS ][ character ].src = fileName

  characters
