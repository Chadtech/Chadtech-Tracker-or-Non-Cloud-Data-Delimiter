# _ = require 'lodash'

module.exports = ->

  assets = {}

  assets[ 'X' ]           = [ new Image(), new Image() ]
  assets[ 'X' ][0].src    = './x-button.png'
  assets[ 'X' ][1].src    = './x-button-selected.png'
  assets[ '<+' ]          = [ new Image(), new Image() ]
  assets[ '<+' ][0].src   = './add-column-button.png'
  assets[ '<+' ][1].src   = './add-column-button-selected.png'

  console.log 'AA', assets
  assets