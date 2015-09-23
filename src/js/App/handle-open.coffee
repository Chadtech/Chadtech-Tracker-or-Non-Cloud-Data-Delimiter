
  handleOpen: ->
    fileImporter = document.getElementById 'fileImporter'

    fileImporter.addEventListener 'change', (event) =>
      csvs      = []
      csvNames  = []
      directory = fs.readdirSync event.target.value
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
          while column.length isnt 15
            column.push ''

        while csv.length isnt 8
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