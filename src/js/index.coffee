global.document   = window.document
global.navigator  = window.navigator


# Libraries
React = require 'react'
_     = require 'lodash'
gui   = require 'nw.gui'


# DOM Elements
{div, input, canvas} = React.DOM


# Utilities
{putPixel, hexToArray, drawText}                     = require './drawingUtilities.js'
CoordinateIsElement                                  = require './coordinate-in-array.js'
{convertToCSVs, zeroPadder, doNothing, Eightx15ify } = require './general-utilities.js'
WorkArea = (doc) ->
  WorkArea = doc.getElementById 'workarea'
  WorkArea = WorkArea.getContext '2d', alpha: false

# Dependencies
LoadGlyphs    = require './load-Glyphs.js'
AssetLoader   = require './load-assets.js'
AllCharacters = require './all-characters.js'
Keys          = ((Keys) -> 

  output = {}
  _.forEach (_.keys Keys), (key) ->
    output[ Keys[ key ]] = key
  _.forEach (_.keys Keys), (key) ->
    output[ key ] = Keys[ key ] 
  output

  ) require './keys.js'


# Drawing
DrawEveryCell       = require './draw-every-cell.js'
DrawSelectedCell    = require './draw-selected-cell.js'
DrawColumnOptions   = require './draw-column-options.js'
DrawColumnNames     = require './draw-column-names.js'
DrawColumnBoxes     = require './draw-column-boxes.js'
DrawRowOptions      = require './draw-row-options.js'
DrawRowNames        = require './draw-row-names.js'
DrawRowBoxes        = require './draw-row-boxes.js'
DrawOriginMark      = require './draw-origin-mark.js'
DrawNormalCell      = require './draw-normal-cell.js'
DrawSheetTabs       = require './draw-sheet-tabs.js'
DrawEveryCellBorder = require './draw-every-cell-border.js'
DrawEveryCellData   = require './draw-every-cell-data.js'
ClearAllCellGlyphs  = require './clear-all-cell-glyphs.js'


# Colors
lighterGray   = '#c0c0c0'
gray          = '#808080'
darkGray      = '#404040'
darkerGray    = '#202020'
borderGray    = '#101010'

cellColor     = hexToArray darkGray
edgeColor     = hexToArray darkerGray
selectedColor = hexToArray lighterGray
borderColor   = hexToArray borderGray
topEdgeColor  = hexToArray gray


# Images for each character
Glyphs = undefined


# Dimensions
toolbarSize = 35
cell =
  w: 6 + (11 * 5)
  h: 7 +  19


# Assets
Assets = undefined 


buttonXBoundaries =
  'open':   [ 4,   55  ]
  'save':   [ 56,  108 ]
  'radix':  [ 264, 287 ]


buttonFunctions = 
  open:
    down: (ctx) ->
      ctx.drawImage Assets['open'][1], buttonXBoundaries.open[0], 4
    up: (ctx, handleOpen) ->
      handleOpen()
      ctx.drawImage Assets['open'][0], buttonXBoundaries.open[0], 4

  save:
    down: (ctx) ->
      ctx.drawImage Assets['save'][1], buttonXBoundaries.save[0], 4
    up: (ctx, handleSave, handleSaveAs, saveFilePath)->
      if saveFilePath isnt ''
        handleSave()
      else
        handleSaveAs()
      ctx.drawImage Assets['save'][0], buttonXBoundaries.save[0], 4


# Main Globals
currentSheet  = 0
sheetNames    = [ ]
Sheets        = [ ]
selectedCells = [ [ 2, 3 ] ]
justSelected  = true
cellXOrg      = 0
cellYOrg      = 0
rowNameRadix  = 8
newSheetName  = 'newSheet'
sheetNameJustSelected = false
keyArea       = 'workarea'


Index = React.createClass


  getInitialState: ->
    windowWidth:    window.innerWidth
    windowHeight:   window.innerHeight
    workareaHeight: window.innerHeight - (2 * toolbarSize)
    filePath:       ''


  componentDidMount: ->

    WorkArea document

    init = =>

      _.forEach [ 0 .. 4 ], ( CS ) ->
        thisScheme = Glyphs.images[ CS ]
        _.forEach (_.keys thisScheme), (key) ->
          character = thisScheme[ key ]

          glyphCanvas = document.createElement 'canvas'
          glyphCanvas.width   = 11
          glyphCanvas.height  = 19
          glyphCtx = glyphCanvas.getContext '2d'
          glyphCtx.drawImage character, 0, 0

          thisScheme[ key ] = glyphCanvas

        Glyphs.images[ CS ] = thisScheme

      document.addEventListener 'keyup',   @onKeyUp
      document.addEventListener 'keydown', @onKeyDown

      @setCanvasDimensions()
      @drawToolBar0()
      @drawToolBar1()
      @refreshWorkArea()

      fileExporter = document.getElementById 'fileExporter'
      nwDir        = window.document.createAttribute 'nwdirectory'
      fileExporter.setAttributeNode nwDir

      fileImporter = document.getElementById 'fileImporter'
      nwDir        = window.document.createAttribute 'nwdirectory'
      fileImporter.setAttributeNode nwDir

    next = =>
      Assets = AssetLoader init

    Glyphs                 = LoadGlyphs AllCharacters, next
    Glyphs.characterWidth  = 11
    Glyphs.characterHeight = 19
  setCanvasDimensions: ->
    toolbar0        = document.getElementById 'toolbar0'
    toolbar0.width  = window.innerWidth
    toolbar0.height = toolbarSize

    toolbar1        = document.getElementById 'toolbar1'
    toolbar1.width  = window.innerWidth
    toolbar1.height = toolbarSize

    workarea        = document.getElementById 'workarea'
    workarea.width  = window.innerWidth
    workarea.height = window.innerHeight - (2 * toolbarSize)


  drawToolBar0: ->
    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d'

    for point in [ 0 .. window.innerWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar0, cellColor, [ point, toolbarSize - 2 ]

    toolbar0.drawImage Assets[ 'open' ][0], 4,  4
    toolbar0.drawImage Assets[ 'save' ][0], 57, 4
    drawText toolbar0, Glyphs, 6, 'column radix:', [ 121, 8 ]
    toolbar0.drawImage Assets[ 'radix-area'][0], 264, 4
    drawText toolbar0, Glyphs, 2, (rowNameRadix.toString 36), [ 270, 9 ]


  drawToolBar1: ->
    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    toolbar1.fillStyle = '#202020'
    toolbar1.fillRect 0, 0, window.innerWidth, toolbarSize

    for point in [ 0 .. window.innerWidth - 1 ]
      borderColor = hexToArray borderGray
      putPixel toolbar1, borderColor, [ point, 2 ]
      putPixel toolbar1, borderColor, [ point, 3 ]

    sheetXOrg = 5

    _.forEach Sheets, (sheet, sheetIndex) ->
      sheetName = sheetNames[ sheetIndex ]

      tabWidth = (9 * Glyphs.characterWidth) + 21

      toolbar1.fillStyle = '#202020'
      toolbar1.fillRect sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1

      for point in [ 0 .. tabWidth ]
        putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 4 ]
        putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     cell.h + 5 ]

      for point in [ 0 .. cell.h + 1 ]
        putPixel toolbar1, cellColor,   [ sheetXOrg,                point + 3 ]
        putPixel toolbar1, cellColor,   [ sheetXOrg - 1,            point + 4 ]
        putPixel toolbar1, borderColor, [ sheetXOrg + tabWidth - 1, point + 3 ]

      if sheetIndex isnt currentSheet

        for point in [ 0 .. tabWidth ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     2 ]
          putPixel toolbar1, borderColor, [ sheetXOrg + point - 1,     3 ]

      formattedName = sheetName
      if formattedName.length > 7
        while formattedName.length > 5
          formattedName = formattedName.substring 0, formattedName.length - 1
        formattedName += '..'

      glyphXOrg     = sheetXOrg
      glyphXOffset  = (tabWidth - 21) // 2
      glyphXOffset -= (11 * formattedName.length) // 2
      glyphXOrg    += glyphXOffset

      drawText toolbar1, Glyphs, 6, formattedName, [ glyphXOrg, 9 ]

      toolbar1.drawImage Assets['X'][0], sheetXOrg + tabWidth - 26, 5

      sheetXOrg += tabWidth + 4

    toolbar1.drawImage Assets['new-sheet-area'][0], window.innerWidth - 28 - 97, 6
    toolbar1.drawImage Assets['+'][0], window.innerWidth - 28, 6
    drawText toolbar1, Glyphs, 2, newSheetName, [ window.innerWidth - 28 - 97 + 6, 9 ]


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


  handleClickToolbar0: (event) ->

    mouseX = event.clientX
    mouseY = event.clientY

    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d', alpha: false

    _.forEach (_.keys buttonXBoundaries), (key) =>
      button = buttonXBoundaries[ key ]
      if (mouseX > button[0]) and (button[1] > mouseX)
        @buttonToFunction toolbar0, key, event.type


  buttonToFunction: (ctx, button, direction) ->
    switch direction
      
      when 'mouseup'
        switch button
          
          when 'save'
            buttonFunctions.save.up ctx, @handleSave, @handleSaveAs, @state.filePath
      
          when 'open'
            buttonFunctions.open.up ctx, @handleOpen

          when 'radix'
            keyArea = 'toolbar0'

      when 'mousedown'
        switch button
          
          when 'save'
            buttonFunctions.save.down ctx

          when 'open'
            buttonFunctions.open.down ctx


  handleClickToolbar1: (event) ->

    toolbar1 = document.getElementById 'toolbar1'
    toolbar1 = toolbar1.getContext '2d'

    mouseX = event.clientX
    mouseY = event.clientY

    tabWidth = (9 * Glyphs.characterWidth) + 21

    whichTab = mouseX - 5
    whichTab = whichTab // tabWidth

    # If the user clicked on a tab
    # and not a gap between tabs
    if (tabWidth - 4) > ((mouseX - 5) % tabWidth )
      if not (whichTab > (Sheets.length - 1))

        # If they clicked on the X
        if ((mouseX - 5) % tabWidth ) > (tabWidth - 25)
          Sheets.splice whichTab, 1
          sheetNames.splice whichTab, 1
          if currentSheet > whichTab
            currentSheet--

        else
          currentSheet  = whichTab
          cellXOrg      = 0
          cellYOrg      = 0
          @DrawSelectedCellsNormal()
          selectedCells = [ [ 0, 0 ] ]

        @DrawRowNames()
        @ClearAllCellGlyphs()
        @DrawEveryCellData()
        @drawToolBar1()
        @DrawSelectedCellsSelected()

    # Steal the key listener to the
    # new sheet name field
    leftSheetNameEdge  = window.innerWidth - 28 - 97
    rightSheetNameEdge = window.innerWidth - 28
    
    if leftSheetNameEdge < mouseX
      if mouseX < rightSheetNameEdge
        keyArea = 'toolbar1'
        newSheetName = ''
        @drawToolBar1()

    # Add the new sheet
    leftNewTabButtonEdge  = window.innerWidth - 28
    rightNewTabButtonEdge = window.innerWidth - 4
    
    if leftNewTabButtonEdge < mouseX
      if mouseX < rightNewTabButtonEdge

        toolbar1.drawImage Assets['+'][1], window.innerWidth - 28, 6

        next = =>
          keyArea = 'workarea'
          Sheets.push _.clone (require './new-sheet.js'), true
          sheetNames.push newSheetName
          newSheetName = 'newSheet'
          @refreshWorkArea()
          @drawToolBar1()
          toolbar1.drawImage Assets['+'][0], window.innerWidth - 28, 6 

        setTimeout next, 100


  handleSaveAs: ->
    csvs = convertToCSVs Sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    fileExporter = document.getElementById 'fileExporter'

    fileExporter.addEventListener 'change', (event) =>
      @setState filePath: event.target.value
      # _.forEach csvs, (csv, csvIndex) =>
      #   filePath = event.target.value
      #   fileName = '/' + sheetNames[ csvIndex ]
      #   fileName += '.csv'
      #   filePath += fileName
      #   fs.writeFileSync filePath, csv
      filePath = event.target.value
      fileName = '/' + sheetNames[ currentSheet ]
      fileName += '.csv'
      filePath += fileName
      fs.writeFileSync filePath, csvs[ currentSheet ]

    fileExporter.click()


  handleSave: ->
    csvs = convertToCSVs Sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    # _.forEach csvs, (csv, csvIndex) =>
      # filePath = @state.filePath
      # fileName = '/' + sheetNames[ csvIndex ]
      # fileName += '.csv'
      # filePath += fileName
      # fs.writeFileSync filePath, csv
    filePath = @state.filePath
    fileName = '/' + sheetNames[ currentSheet ]
    fileName += '.csv'
    filePath += fileName
    fs.writeFileSync filePath, csvs[ currentSheet ]


  handleOpen: ->
    fileImporter = document.getElementById 'fileImporter'

    fileImporter.addEventListener 'change', (event) =>
      csvs      = []
      csvNames  = []
      directory = fs.readdirSync event.target.value

      @setState filePath: event.target.value

      _.forEach directory, (f) ->
        ending = f.substring f.length - 4, f.length
        if ending is '.csv'
          csvs.push event.target.value + '/' + f
          csvNames.push f.substring 0, f.length - 4
      csvs  = _.map csvs, (csv) ->
        csv = fs.readFileSync csv, 'utf-8'
        csv = csv.split '\n'
        csv = _.map csv, (column) ->
          column.split ','

      _.forEach csvs, (csv) ->
        _.forEach csv, (column) ->
          while column.length < 15
            console.log 'C.4'
            column.push ''

        while csv.length < 8
          console.log  'C.5', csv.length
          thisNewColumn = []
          _.times 15, ->
            thisNewColumn.push ''
          csv.push thisNewColumn

      Sheets     = csvs
      sheetNames = csvNames

      @refreshWorkArea()
      @drawToolBar0()
      @drawToolBar1()

    fileImporter.click()


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



              
  render: ->

    div
      style:
        backgroundColor:    darkerGray
        width:              '100%'
        height:             '100%'
        margin:             0
        padding:            0
        position:           'absolute'
        top:                0
        left:               0

      canvas
        id:                 'toolbar0'
        onMouseDown:        @handleClickToolbar0
        onMouseUp:          @handleClickToolbar0
        style:
          backgroundColor:  darkerGray
          width:            '100%'
          height:           toolbarSize
          imageRendering:   'pixelated'

      canvas
        id:                 'toolbar1'
        onMouseDown:        @handleClickToolbar1
        style:
          backgroundColor:  darkerGray
          position:         'absolute'
          top:              @state.windowHeight - toolbarSize
          left:             0
          width:            '100%'
          height:           toolbarSize
          imageRendering:   'pixelated'

      canvas
        id:                 'workarea'
        onMouseDown:        @handleClickWorkArea
        style:
          backgroundColor:  darkerGray
          position:         'absolute'
          top:              toolbarSize
          left:             0
          width:            '100%'
          height:           @state.workareaHeight
          imageRendering:   'pixelated'



Index          = React.createElement Index
injectionPoint = document.getElementById 'content'
React.render Index, injectionPoint


