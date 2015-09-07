module.exports = ->

  image = ->
    document.createElement 'IMG'

  assets = {}

  assets[ 'X' ]           = [ image(), image() ]
  assets[ 'X' ][0].src    = './x-button.png'
  assets[ 'X' ][1].src    = './x-button-selected.png'

  assets[ '<+' ]          = [ image(), image() ]
  assets[ '<+' ][0].src   = './add-column-button.png'
  assets[ '<+' ][1].src   = './add-column-button-selected.png'

  assets