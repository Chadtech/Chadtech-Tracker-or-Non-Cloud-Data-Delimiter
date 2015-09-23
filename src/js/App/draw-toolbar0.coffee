  drawToolBar0: ->
    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d'

    for point in [ 0 .. window.innerWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar0, cellColor, [ point, toolbarSize - 2 ]

    toolbar0.drawImage Assets[ 'open' ][0], 4,  4
    toolbar0.drawImage Assets[ 'save' ][0], 57, 4
    drawText toolbar0, Glyphs, 6, 'column radix:', [ 121, 8 ]
    toolbar0.drawImage Assets[ 'radix-area'][0], 264, 4
    drawText toolbar0, Glyphs, 2, rowNameRadix + '', [ 270, 9 ]

