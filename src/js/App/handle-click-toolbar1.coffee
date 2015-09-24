  handleClickToolbar1: (event) ->

    mouseX = event.clientX
    mouseY = event.clientY

    tabWidth = (9 * Glyphs.characterWidth) + 21

    whichTab = mouseX - 5
    whichTab = whichTab // tabWidth

    # If the user clicked on a tab
    # and not a gap between tabs
    if (tabWidth - 4) > ((mouseX - 5) % tabWidth )
      if not (whichTab > (Sheets.length - 1))

        console.log currentSheet

        if ((mouseX - 5) % tabWidth ) > (tabWidth - 25)
          Sheets.splice whichTab, 1
          sheetNames.splice whichTab, 1
          if currentSheet > whichTab
            currentSheet--
        else
          currentSheet = whichTab

        @DrawRowNames()
        @ClearAllCellGlyphs()
        @DrawEveryCellData()
        @drawToolBar1()

    leftSheetNameEdge  = window.innerWidth - 28 - 97
    rightSheetNameEdge = window.innerWidth - 28
    
    if leftSheetNameEdge < mouseX
      if mouseX < rightSheetNameEdge
        keyArea = 'toolbar1'
        newSheetName = ''
        @drawToolBar1()

    leftNewTabButtonEdge  = window.innerWidth - 28
    rightNewTabButtonEdge = window.innerWidth - 4
    
    if leftNewTabButtonEdge < mouseX
      if mouseX < rightNewTabButtonEdge
        keyArea = 'workarea'
        Sheets.push _.clone (require './new-sheet.js'), true
        sheetNames.push newSheetName
        newSheetName = 'newSheet'
        @refreshWorkArea()
        @drawToolBar1()

