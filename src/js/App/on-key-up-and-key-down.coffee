
  onKeyDown: (event) ->

    switch keyArea
        
      when 'workarea'
        if event.metaKey

          Next = => return

          refreshCellData = (first) =>
            first()
            @ClearAllCellGlyphs()
            @DrawEveryCellData()

          switch event.which

            when Keys['backspace']
              if justSelected
                justSelected = false
              SC = selectedCells[0]
              Sheets[ currentSheet ][ SC[ 1 ] + cellXOrg ][ SC[ 0 ] + cellYOrg ] = ''

            when Keys['enter']
              justSelected = true
              Next = =>
                selectedCells[0][0]++

            when Keys['down']
              if (selectedCells[0][0] + cellYOrg) < (Sheets[currentSheet][0].length - 21)
                justSelected = true

                Next = =>
                  _.times 20, =>
                    if (selectedCells[0][0] % 15) is 14
                      cellYOrg++
                      refreshCellData @DrawRowNames
                    else
                      selectedCells[0][0]++
            
            when Keys['up']
              if 0 < (selectedCells[0][0] + cellYOrg)
                justSelected = true
                Next = =>
                  _.times 20, =>
                    if (selectedCells[0][0] % 15) is 0
                      if cellYOrg isnt 0 then cellYOrg--
                      refreshCellData @DrawRowNames
                    else
                      if selectedCells[0][0] isnt 0 then selectedCells[0][0]--

            when Keys['ctrl' ] then doNothing()
            when Keys['shift'] then doNothing()
            when Keys['alt'  ] then doNothing()

            else

              SC = [
                  selectedCells[0][0] + cellYOrg
                  selectedCells[0][1] + cellXOrg
                ] 
              thisCell = Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ]
              thisKey  = Keys[ event.which ]
              if thisKey is 'space'
                thisKey = ' '

              if thisKey.length is 1
                if event.shiftKey
                  if justSelected
                    justSelected = false
                    thisCell     = thisKey.toUpperCase()
                  else
                    thisCell    += thisKey.toUpperCase()
                else
                  if justSelected
                    justSelected = false
                    thisCell     = thisKey
                  else
                    thisCell    += thisKey

              Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = thisCell
          
          @DrawSelectedCellsNormal()
          Next()
          @DrawSelectedCellsSelected()

          if event.which is Keys['s']
            if @state.filePath
              @handleSave()
            else 
              @handleSaveAs()

            toolbar0 = document.getElementById 'toolbar0'
            toolbar0 = toolbar0.getContext '2d'

            returnToUnclicked = =>
              toolbar0.drawImage Assets['save'][0], buttonXBoundaries.save[0], 4 

            toolbar0.drawImage Assets['save'][1], buttonXBoundaries.save[0], 4 
            setTimeout returnToUnclicked, 300

        else
          
          if selectedCells.length is 1

            Next = => return

            refreshCellData = (first) =>
              first()
              @ClearAllCellGlyphs()
              @DrawEveryCellData()

            switch event.which

              when Keys['backspace']
                if justSelected
                  justSelected = false
                SC = selectedCells[0]
                Sheets[ currentSheet ][ SC[ 1 ] + cellXOrg ][ SC[ 0 ] + cellYOrg ] = ''

              when Keys['enter']
                justSelected = true
                Next = =>
                  selectedCells[0][0]++

              when Keys['down']
                if (selectedCells[0][0] + cellYOrg) < (Sheets[currentSheet][0].length - 1)
                  justSelected = true

                  Next = =>
                    if (selectedCells[0][0] % 15) is 14
                      cellYOrg++
                      refreshCellData @DrawRowNames
                    else
                      selectedCells[0][0]++
              
              when Keys['up']
                if 0 < (selectedCells[0][0] + cellYOrg)
                  justSelected = true
                  Next = =>
                    if (selectedCells[0][0] % 15) is 0
                      cellYOrg--
                      refreshCellData @DrawRowNames
                    else
                      selectedCells[0][0]--

              when Keys['right']
                if (selectedCells[0][1] + cellXOrg) < (Sheets[currentSheet].length - 1)
                  justSelected = true
                  Next = =>
                    if (selectedCells[0][1] % 8) is 7
                      cellXOrg++
                      refreshCellData @DrawColumnNames
                    else
                      selectedCells[0][1]++
              
              when Keys['left']
                if 0 < (selectedCells[0][1] + cellXOrg)
                  justSelected = true
                  Next = =>
                    if (selectedCells[0][1] % 8) is 0
                      cellXOrg--
                      refreshCellData @DrawColumnNames
                    else
                      selectedCells[0][1]--

              when Keys['ctrl' ] then doNothing()
              when Keys['shift'] then doNothing()
              when Keys['alt'  ] then doNothing()

              else

                SC = [
                    selectedCells[0][0] + cellYOrg
                    selectedCells[0][1] + cellXOrg
                  ] 
                thisCell = Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ]
                thisKey  = Keys[ event.which ]
                if thisKey is 'space'
                  thisKey = ' '

                if thisKey.length is 1
                  if event.shiftKey
                    if justSelected
                      justSelected = false
                      thisCell     = thisKey.toUpperCase()
                    else
                      thisCell    += thisKey.toUpperCase()
                  else
                    if justSelected
                      justSelected = false
                      thisCell     = thisKey
                    else
                      thisCell    += thisKey

                Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = thisCell
            
            @DrawSelectedCellsNormal()
            Next()
            @DrawSelectedCellsSelected()

      when 'toolbar0'
        rowNameRadix = parseInt (Keys[ event.which ].slice 0, 1), 36
        @drawToolBar0()
        @DrawRowNames()

      when 'toolbar1'
        if Keys[ event.which ].length is 1
          newSheetName += Keys[ event.which ]
          @drawToolBar1()


