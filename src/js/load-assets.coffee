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

  assets[ '^+' ]          = [ image(), image() ]
  assets[ '^+' ][0].src   = './add-row-button.png'
  assets[ '^+' ][1].src   = './add-row-button-selected.png'

  assets[ 'save ']        = [ image(), image() ]
  assets[ 'save '][0].src = './save.ong'
  assets[ 'save '][1].src = './save-selected.ong'

  assets[ 'open ']        = [ image(), image() ]
  assets[ 'open '][0].src = './open.ong'
  assets[ 'open '][1].src = './open-selected.ong'

  assets