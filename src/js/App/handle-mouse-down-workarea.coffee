
  handleClickWorkArea: (event) ->
    keyArea = 'workarea'

    mouseX = event.clientX
    mouseY = event.clientY
    mouseX -= cell.w
    mouseY -= cell.h
    mouseY -= toolbarSize + 5

    whichCell = [ 
      ((mouseY + 6) // cell.h) - 1
      (mouseX // cell.w) - 1
    ]

    if not event.metaKey
      if (whichCell[0] < 0) or (whichCell[1] < 0)

        # If they clicked the column name
        if whichCell[0] is -1
          thisColumn = Sheets[ currentSheet ][ whichCell[1] ]
          @DrawSelectedCellsNormal()
          selectedCells = []
          _.forEach thisColumn, (row, rowIndex) ->
            selectedCells.push [ rowIndex, whichCell[1] ]
          @DrawSelectedCellsSelected()

        # If they clicked either delete column or new column
        if whichCell[0] is -2
          # Delete column
          if (mouseX % cell.w) < 25
            Sheets[currentSheet].splice whichCell[1], 1
            @ClearAllCellGlyphs()
            @DrawEveryCellData()
          # add column
          else
            newColumn = []
            _.forEach Sheets[currentSheet][0], (column) ->
              newColumn.push ''
            Sheets[currentSheet].splice whichCell[1] + 1, 0, newColumn
            @ClearAllCellGlyphs()
            @DrawEveryCellData()

        # If they clicked on the row name
        if whichCell[1] is -1
          @DrawSelectedCellsNormal()
          selectedCells = []
          _.forEach Sheets[ currentSheet ], (column, columnIndex) ->
            selectedCells.push [ whichCell[0], columnIndex]
          @DrawSelectedCellsSelected()

        # If they clicked on delete row or new row
        if whichCell[1] is -2
          # delete row
          if ((mouseX + cell.w) % cell.w) < 25
            _.forEach Sheets[currentSheet], (column) ->
              column.splice whichCell[0], 1         
            @ClearAllCellGlyphs()
            @DrawEveryCellData()
          # add row
          else
            _.forEach Sheets[currentSheet], (column) ->
              column.splice whichCell[0] + 1, 0, ''
            @ClearAllCellGlyphs()
            @DrawEveryCellData()


      else
        @DrawSelectedCellsNormal()   
        selectedCells = [ whichCell ]
        @DrawSelectedCellsSelected()
        justSelected = true

    else
      unless CoordinateIsElement selectedCells, whichCell
        selectedCells.push whichCell
        @DrawSelectedCell whichCell
        # DrawSelectedCell Sheets[ currentSheet ], workarea, Glyphs, selectedColor, cell, whichCell

