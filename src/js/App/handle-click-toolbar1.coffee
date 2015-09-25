  handleClickToolbar1: (event) ->

    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    mouseX = event.clientX
    mouseY = event.clientY

    tabWidth = (9 * Glyphs.characterWidth) + 21

    whichTab = mouseX - 5
    whichTab = whichTab // tabWidth

    # If the user clicked on a tab
    # and not a gap between tabs
    if (tabWidth - 4) > ((mouseX - 5) % tabWidth )
      if not (whichTab > (Sheets.length - 1))

        # If they clicked on the X
        if ((mouseX - 5) % tabWidth ) > (tabWidth - 25)
          Sheets.splice whichTab, 1
          sheetNames.splice whichTab, 1
          if currentSheet > whichTab
            currentSheet--

        else
          currentSheet  = whichTab
          cellXOrg      = 0
          cellYOrg      = 0
          @DrawSelectedCellsNormal()
          selectedCells = [ [ 0, 0 ] ]

        @DrawRowNames()
        @ClearAllCellGlyphs()
        @DrawEveryCellData()
        @drawToolBar1()
        @DrawSelectedCellsSelected()

    # Steal the key listener to the
    # new sheet name field
    leftSheetNameEdge  = window.innerWidth - 28 - 97
    rightSheetNameEdge = window.innerWidth - 28
    
    if leftSheetNameEdge < mouseX
      if mouseX < rightSheetNameEdge
        keyArea = 'toolbar1'
        newSheetName = ''
        @drawToolBar1()

    # Add the new sheet
    leftNewTabButtonEdge  = window.innerWidth - 28
    rightNewTabButtonEdge = window.innerWidth - 4
    
    if leftNewTabButtonEdge < mouseX
      if mouseX < rightNewTabButtonEdge

        toolbar1.drawImage Assets['+'][1], window.innerWidth - 28, 6

        next = =>
          keyArea = 'workarea'
          Sheets.push _.clone (require './new-sheet.js'), true
          sheetNames.push newSheetName
          newSheetName = 'newSheet'
          @refreshWorkArea()
          @drawToolBar1()
          toolbar1.drawImage Assets['+'][0], window.innerWidth - 28, 6 

        setTimeout next, 100

