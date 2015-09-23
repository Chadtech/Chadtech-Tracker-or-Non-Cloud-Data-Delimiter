  handleClickToolbar1: (event) ->

    mouseX = event.clientX
    mouseY = event.clientY

    whichTab = mouseX - 5
    whichTab = whichTab // 99

    # If the user clicked on a tab
    # and not a gap between tabs
    if 95 > ((mouseX - 5) % 99 )
      if not (whichTab > (Sheets.length - 1))
        currentSheet = whichTab
        @DrawRowNames()
        @ClearAllCellGlyphs()
        @DrawEveryCellData()
        @drawToolBar1()

    tabWidth = (9 * Glyphs.characterWidth) + 21
    leftNewTabButtonEdge = 5 + (tabWidth + 4) * Sheets.length
    leftNewTabButtonEdge += 97
    
    if leftNewTabButtonEdge < mouseX
      if mouseX < (leftNewTabButtonEdge + 24)
        Sheets.push (require './new-sheet.js')
        sheetNames.push newSheetName
        sheetNames .push 'newSheet'
        @refreshWorkArea()
        @drawToolBar1()
