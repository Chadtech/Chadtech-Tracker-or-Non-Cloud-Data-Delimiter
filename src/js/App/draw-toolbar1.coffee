  drawToolBar1: ->
    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    for point in [ 0 .. window.innerWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar1, borderColor, [ point, 2 ]
      putPixel toolbar1, borderColor, [ point, 3 ]

    sheetXOrg = 5

    _.forEach Sheets, (sheet, sheetIndex) ->
      sheetName = sheetNames[ sheetIndex ]

      tabWidth = (9 * Glyphs.characterWidth) + 21

      toolbar1.fillStyle = '#202020'
      toolbar1.fillRect sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1

      for point in [ 0 .. tabWidth ]
        putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 4 ]
        putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 5 ]

      for point in [ 0 .. cell.h + 1 ]
        putPixel toolbar1, cellColor,   [ sheetXOrg,                point + 3 ]
        putPixel toolbar1, cellColor,   [ sheetXOrg - 1,            point + 4 ]
        putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth - 1, point + 3 ]

      if sheetIndex isnt currentSheet

        for point in [ 0 .. tabWidth ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     3 ]

      glyphXOrg    = sheetXOrg
      glyphXOffset = (tabWidth - 21) // 2
      glyphXOffset -= (11 * sheetName.length) // 2
      glyphXOrg    += glyphXOffset

      drawText toolbar1, Glyphs, 6, sheetName, [ glyphXOrg, 9 ]

      toolbar1.drawImage Assets['X'][0], sheetXOrg + tabWidth - 26, 5

      sheetXOrg += tabWidth + 4

    toolbar1.drawImage Assets['new-sheet-area'][0], sheetXOrg, 6
    toolbar1.drawImage Assets['+'][0], sheetXOrg + 97, 6
    drawText toolbar1, Glyphs, 2, 'food', [ sheetXOrg + 6, 9 ]
