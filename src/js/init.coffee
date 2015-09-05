_ = require 'lodash'

module.exports = (allCharacters) ->

  characterImagesColorScheme0 = {}
  characterImagesColorScheme1 = {}
  characterImagesColorScheme2 = {}

  _.forEach allCharacters, (character, characterIndex) ->
    characterImagesColorScheme0[ character ] = new Image()
    characterImagesColorScheme1[ character ] = new Image()
    characterImagesColorScheme2[ character ] = new Image()


    fileName = '' + characterIndex
    while fileName.length < 3
      fileName = '0' + fileName

    fileName0 = './hfnssC0/hfnssC0_' + fileName + '.png'
    characterImagesColorScheme0[ character ].src = fileName0
    fileName1 = './hfnssC1/hfnssC1_' + fileName + '.png'
    characterImagesColorScheme1[ character ].src = fileName1
    fileName2 = './hfnssC2/hfnssC2_' + fileName + '.png'
    characterImagesColorScheme2[ character ].src = fileName2


    # characterImagesColorScheme1[ character ].onload = =>
    #   # console.log 'IMAGE LOADED', characterIndex

  characterImages =
    images: 
      0: characterImagesColorScheme0
      1: characterImagesColorScheme1
      2: characterImagesColorScheme2

  characterImages
