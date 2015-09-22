
  onKeyUp: (event) ->
    # if event.which is Keys['command']
    #   @setState commandIsDown: false, ->
    #     console.log 'command is marked Up'

  onKeyDown: (event) ->
    
    if event.metaKey

      if event.which is Keys['s']
        if @state.filePath
          @handleSave()
        else 
          @handleSaveAs()

    else
      
      if selectedCells.length is 1

        Next = => return

        switch event.which

          when Keys['backspace']
            if justSelected
              justSelected = false
            SC = selectedCells[0]
            Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ] = ''

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
                  @DrawRowNames()
                  @ClearAllCellGlyphs()
                  @DrawEveryCellData()
                else
                  selectedCells[0][0]++
          
          when Keys['up']
            if 0 < (selectedCells[0][0] + cellYOrg)
              justSelected = true
              Next = =>
                if (selectedCells[0][0] % 15) is 0
                  cellYOrg--
                  @DrawRowNames()
                  @ClearAllCellGlyphs()
                  @DrawEveryCellData()
                else
                  selectedCells[0][0]--


          when Keys['right']
            if selectedCells[0][1] < (Sheets[currentSheet].length - 1)
              justSelected = true
              Next = =>
                selectedCells[0][1]++
          
          when Keys['left']
            if 0 < selectedCells[0][1]
              justSelected = true
              Next = =>
                selectedCells[0][1]--

          when Keys['ctrl']  then doNothing()
          when Keys['shift'] then doNothing()
          when Keys['alt']   then doNothing()

          else

            SC = [
                selectedCells[0][0] + cellYOrg
                selectedCells[0][1] + cellXOrg
              ] 
            # SC = selectedCells[0]
            thisCell = Sheets[ currentSheet ][ SC[ 1 ] ][ SC[ 0 ] ]
            thisKey  = Keys[ event.which ]
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
