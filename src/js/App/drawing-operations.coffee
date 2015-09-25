  Just8x15: ->
    Eightx15ify Sheets[ currentSheet ], cellXOrg, cellYOrg


  DrawSelectedCellsNormal: ->
    for selectedCell in selectedCells
      DrawNormalCell @Just8x15(), WorkArea, Glyphs, cellColor, cell, selectedCell      


  DrawSelectedCellsSelected: ->
    for selectedCell in selectedCells
      DrawSelectedCell @Just8x15(), WorkArea, Glyphs, selectedColor, cell, selectedCell


  DrawSelectedCell: (selectedCell) ->
    DrawSelectedCell @Just8x15(), WorkArea, Glyphs, selectedColor, cell, selectedCell


  ClearAllCellGlyphs: ->
    ClearAllCellGlyphs WorkArea, Glyphs, cellColor, cell


  DrawEveryCellData: ->    
    DrawEveryCellData @Just8x15(), WorkArea, Glyphs, cellColor, cell


  DrawRowNames: ->
    DrawRowNames @Just8x15(), WorkArea, Glyphs, edgeColor, cell, cellYOrg, rowNameRadix


  DrawRowBoxes: ->
    DrawRowBoxes WorkArea, edgeColor, cell


  DrawColumnNames: ->
    DrawColumnNames @Just8x15(), WorkArea, Glyphs, edgeColor, cell, cellXOrg


  DrawColumnBoxes: ->
    DrawColumnBoxes WorkArea, edgeColor, cell


  refreshWorkArea: ->
    sheetName = sheetNames[ currentSheet ]

    WorkArea.fillStyle = '#202020'
    WorkArea.fillRect 0, 0, window.innerWidth, window.innerHeight

    if Sheets.length 

      DrawOriginMark sheetName, WorkArea, Glyphs, edgeColor, cell, Assets
      @DrawColumnBoxes()
      @DrawColumnNames()
      @DrawRowBoxes()
      @DrawRowNames()

      @ClearAllCellGlyphs()
      DrawEveryCellBorder Sheets[ currentSheet ], WorkArea, Glyphs, cellColor, cell
      @DrawEveryCellData()

      DrawColumnOptions Sheets[ currentSheet ], WorkArea, Glyphs, edgeColor, cell, Assets
      DrawRowOptions    Sheets[ currentSheet ], WorkArea, Glyphs, edgeColor, cell, Assets
      
      @DrawSelectedCellsSelected()

