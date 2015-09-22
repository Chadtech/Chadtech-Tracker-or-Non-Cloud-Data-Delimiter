  handleSaveAs: ->
    csvs = convertToCSVs Sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    fileExporter = document.getElementById 'fileExporter'

    fileExporter.addEventListener 'change', (event) =>
      @setState filePath: event.target.value
      _.forEach csvs, (csv, csvIndex) =>
        filePath = event.target.value
        fileName = '/' + sheetNames[ csvIndex ]
        fileName += '.csv'
        filePath += fileName
        fs.writeFileSync filePath, csv
        
    fileExporter.click()


  handleSave: ->
    csvs = convertToCSVs Sheets
    csvs = _.map csvs, (csv) ->
      new Buffer csv, 'utf-8'

    _.forEach csvs, (csv, csvIndex) =>
      filePath = @state.filePath
      fileName = '/' + sheetNames[ csvIndex ]
      fileName += '.csv'
      filePath += fileName
      fs.writeFileSync filePath, csv

