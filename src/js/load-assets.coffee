# _ = require 'lodash'

module.exports = ->

  assets = {}

  assets[ 'X' ] = [ 
    document.createElement 'IMG'
    document.createElement 'IMG'
  ]
  assets[ 'X' ][0].src    = './x-button.png'
  assets[ 'X' ][1].src    = './x-button-selected.png'
  
  assets[ '<+' ]  = [ 
    document.createElement 'IMG'
    document.createElement 'IMG'
  ]
  assets[ '<+' ][0].src   = './add-column-button.png'
  assets[ '<+' ][1].src   = './add-column-button-selected.png'

  console.log 'AA', assets
  assets