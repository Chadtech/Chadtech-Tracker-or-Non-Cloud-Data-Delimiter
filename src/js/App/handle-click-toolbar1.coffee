  handleClickToolbar1: (event) ->

    mouseX = event.clientX
    mouseY = event.clientY

    whichTab = mouseX - 5
    whichTab = whichTab // 99

    # If the user clicked on a tab
    # and not a gap between tabs
    if 95 > ((mouseX - 5) % 99 )
      currentSheet = whichTab
      @DrawRowNames()
      @ClearAllCellGlyphs()
      @DrawEveryCellData()
      @drawToolBar1()
