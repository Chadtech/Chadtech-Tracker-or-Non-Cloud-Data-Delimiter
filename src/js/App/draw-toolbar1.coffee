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

      if sheetIndex isnt currentSheet

        tabWidth = 9 * Glyphs.characterWidth

        toolbar1.fillStyle = '#202020'
        toolbar1.fillRect sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1

        for point in [ 0 .. tabWidth ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     3 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 3 ]

        for point in [ 0 .. cell.h - 1 ]
          putPixel toolbar1, cellColor,   [ sheetXOrg,                point + 3 ]
          putPixel toolbar1, cellColor,   [ sheetXOrg - 1,            point + 4 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth - 1, point + 3 ]
          
        glyphXOrg    = sheetXOrg
        glyphXOffset = tabWidth // 2
        glyphXOffset -= (11 * sheetName.length) // 2
        glyphXOrg    += glyphXOffset

        drawText toolbar1, Glyphs, 6, sheetName, [ glyphXOrg, 7 ]

        sheetXOrg += tabWidth + 4

      else

        tabWidth = sheetName.length + 2
        tabWidth *= Glyphs.characterWidth

        toolbar1.fillStyle = '#202020'
        toolbar1.fillRect sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1

        for point in [ 0 .. tabWidth ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 3 ]

        for point in [ 0 .. cell.h - 1 ]
          putPixel toolbar1, cellColor,   [ sheetXOrg,                point + 3 ]
          putPixel toolbar1, cellColor,   [ sheetXOrg - 1,            point + 4 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth - 1, point + 3 ]

        glyphXOrg    = sheetXOrg
        glyphXOffset = tabWidth // 2
        glyphXOffset -= (11 * sheetName.length) // 2
        glyphXOrg    += glyphXOffset

        drawText toolbar1, Glyphs, 6, sheetName, [ glyphXOrg, 7 ]

        sheetXOrg += tabWidth + 4