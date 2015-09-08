_ = require 'lodash'

module.exports = (sheets) ->

  # makeCSV = (sheets) ->
    
  delimit     = (a, b, delimiter) -> a + delimiter + b
  delimitItem = (a, b) -> delimit a, b, ','
  delimitRow  = (a, b) -> delimit a, (_.reduce b, delimitItem), '\n'
  _.map sheets, (sheet) -> (_.reduce sheet, delimitRow)



