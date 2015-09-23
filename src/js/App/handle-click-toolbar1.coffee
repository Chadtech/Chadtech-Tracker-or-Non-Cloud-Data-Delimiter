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

        if ((mouseX - 5) % tabWidth ) > (tabWidth - 25)
          console.log Sheets.length, whichTab, Sheets
          Sheets.splice whichTab, 1
          sheetNames.splice whichTab, 1
          console.log Sheets.length, whichTab, Sheets
          if whichTab > 0
            currentSheet--
        else
          currentSheet = whichTab

        @DrawRowNames()
        @ClearAllCellGlyphs()
        @DrawEveryCellData()
        @drawToolBar1()

    tabWidth = (9 * Glyphs.characterWidth) + 21
    leftNewTabButtonEdge  = 5 + (tabWidth + 4) * Sheets.length
    leftNewTabButtonEdge += 97
    
    if leftNewTabButtonEdge < mouseX
      if mouseX < (leftNewTabButtonEdge + 24)
        Sheets.push _.clone (require './new-sheet.js'), true
        sheetNames.push newSheetName
        newSheetName = 'newSheet'
        @refreshWorkArea()
        @drawToolBar1()
