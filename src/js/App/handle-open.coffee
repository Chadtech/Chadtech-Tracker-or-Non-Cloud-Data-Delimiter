
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
