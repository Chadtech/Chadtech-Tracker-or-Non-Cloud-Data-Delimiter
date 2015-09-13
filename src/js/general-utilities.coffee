_ = require 'lodash'

module.exports = 


  convertToCSVs: (sheets) ->
    
    delimit     = (a, b, delimiter) -> a + delimiter + b
    delimitItem = (a, b) -> delimit a, b, ','
    delimitRow  = (a, b) -> delimit a, (_.reduce b, delimitItem), '\n'
    _.map sheets, (sheet) -> (_.reduce sheet, delimitRow)


  zeroPadder: (padTo, paddee) ->
    paddee = paddee + ''
    while paddee.length < padTo
      paddee = '0' + paddee
    paddee

  doNothing: ->