fs = require 'fs'
gm = require 'gm'

hfnss = gm './hfnssForComputers.png'

hfnss.size (err, size) ->
  if not err

    for column in [ 0 .. (size.width // 12) - 1]
      for row in [ 0 .. (size.height // 20) - 1]

        xCor = 12 * column
        yCor = 20 * row
        xCor++
        yCor++

        thisCharacter = gm './hfnssForComputers6.png'
          .crop 11, 19, xCor, yCor

        fileName = '' + (column + ( row * 15 )) + '.png'
        while fileName.length < 7
          fileName = '0' + fileName

        thisCharacter.write './' + 'hfnssC6_' + fileName, (err) ->
          if err
            console.log 'A', err
          else
            console.log 'YE SAVED'