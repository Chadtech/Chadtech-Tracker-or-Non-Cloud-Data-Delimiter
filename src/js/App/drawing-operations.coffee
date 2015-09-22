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
    DrawRowNames @Just8x15(),  WorkArea, Glyphs, edgeColor, cell, cellYOrg


  DrawRowBoxes: ->
    DrawRowBoxes WorkArea, edgeColor, cell


  refreshWorkArea: ->
    sheetName = sheetNames[ currentSheet ]

    WorkArea.fillStyle = '#000000'
    WorkArea.fillRect 0, 0, window.innerWidth, window.innerHeight

    DrawOriginMark    sheetName,    WorkArea, Glyphs, edgeColor, cell, Assets
    DrawColumnNames   @Just8x15(),  WorkArea, Glyphs, edgeColor, cell, cellXOrg
    DrawRowBoxes                    WorkArea,         edgeColor, cell
    DrawRowNames      @Just8x15(),  WorkArea, Glyphs, edgeColor, cell, cellYOrg

    @ClearAllCellGlyphs()
    DrawEveryCellBorder Sheets[ currentSheet ], WorkArea, Glyphs, cellColor, cell
    @DrawEveryCellData()

    DrawColumnOptions Sheets[ currentSheet ], WorkArea, Glyphs, edgeColor, cell, Assets
    DrawRowOptions    Sheets[ currentSheet ], WorkArea, Glyphs, edgeColor, cell, Assets
    
    @DrawSelectedCellsSelected()

