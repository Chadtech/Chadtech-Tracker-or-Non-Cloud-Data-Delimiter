
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

    refreshCells = =>
      @ClearAllCellGlyphs()
      @DrawEveryCellData()

    refreshSelectedCells = (update) =>
      @DrawSelectedCellsNormal()
      update()
      @DrawSelectedCellsSelected()

    if not event.metaKey
      if (whichCell[0] < 0) or (whichCell[1] < 0)

        # If they clicked the column name
        if whichCell[0] is -1
          thisColumn = Sheets[ currentSheet ][ whichCell[1] ]
          refreshSelectedCells =>
            selectedCells = []
            _.forEach thisColumn, (row, rowIndex) ->
              selectedCells.push [ rowIndex, whichCell[1] ]

        # If they clicked either delete column or new column
        if whichCell[0] is -2

          # Delete column
          if (mouseX % cell.w) < 25
            Sheets[currentSheet].splice whichCell[1] + cellXOrg, 1
            refreshCells()

            xCor = (whichCell[1] + 2) * (cell.w - 1)
            xCor += 2
            WorkArea.drawImage Assets['X'][1], xCor, 0
            restoreXButton = =>
              WorkArea.drawImage Assets['X'][0], xCor, 0
            setTimeout restoreXButton, 100

            if Sheets[ currentSheet ].length < 8
              newColumn = []
              _.times Sheets[ currentSheet ].length, ->
                newColumn.push ''
              Sheets[currentSheet].push newColumn

          # add column
          else
            newColumn = []
            _.forEach Sheets[currentSheet][0], (column) ->
              newColumn.push ''
            Sheets[currentSheet].splice whichCell[1] + cellXOrg + 1, 0, newColumn
            refreshCells()

            xCor = (whichCell[1] + 2) * (cell.w - 1)
            xCor += 27
            WorkArea.drawImage Assets['<+'][1], xCor, 0
            restoreNewColumnButton = =>
              WorkArea.drawImage Assets['<+'][0], xCor, 0
            setTimeout restoreNewColumnButton, 100

        # If they clicked on the row name
        if whichCell[1] is -1
          refreshSelectedCells =>
            selectedCells = []
            _.forEach Sheets[ currentSheet ], (column, columnIndex) ->
              selectedCells.push [ whichCell[0], columnIndex ]


        # If they clicked on delete row or new row
        if whichCell[1] is -2

          # delete row
          if ((mouseX + cell.w) % cell.w) < 25
            _.forEach Sheets[currentSheet], (column) ->
              column.splice whichCell[0] + cellYOrg, 1         
            refreshCells()

            yCor = (whichCell[0] + 2) * (cell.h - 1)
            WorkArea.drawImage   Assets['X'][1], 1, yCor
            restoreXButton = =>
              WorkArea.drawImage Assets['X'][0], 1, yCor
            setTimeout restoreXButton, 100

            if Sheets[ currentSheet ][0].length < 15
              newColumn = []
              _.forEach Sheets[ currentSheet ], (column, columnIndex) ->
                Sheets[ currentSheet ][ columnIndex ].push ''

          # add row
          else
            _.forEach Sheets[currentSheet], (column) ->
              column.splice whichCell[0] + cellYOrg + 1, 0, ''
            refreshCells()

            yCor = (whichCell[0] + 2) * (cell.h - 1)
            WorkArea.drawImage   Assets['^+'][1], 26, yCor
            restoreXButton = =>
              WorkArea.drawImage Assets['^+'][0], 26, yCor
            setTimeout restoreXButton, 100


      else
        @DrawSelectedCellsNormal()   
        selectedCells = [ whichCell ]
        @DrawSelectedCellsSelected()
        justSelected = true

    else
      unless CoordinateIsElement selectedCells, whichCell
        selectedCells.push whichCell
        @DrawSelectedCell whichCell

