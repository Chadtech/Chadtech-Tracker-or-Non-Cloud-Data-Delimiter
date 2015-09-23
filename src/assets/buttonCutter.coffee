fs = require 'fs'
gm = require 'gm'
_  = require 'lodash'

destination = './../../resources/'

cutButton = (saveFile, a) =>
  img = gm './buttonSprites.png'
  img.crop a[0], a[1], a[2], a[3]
  img.write destination + saveFile + '.png', (err) ->
    if err
      console.log err

buttonsToCut = [
  [ 'x-button',                   [ 24, 24, 35, 0  ] ]
  [ 'x-button-selected',          [ 24, 24, 35, 24 ] ]
  [ 'add-column-button',          [ 35, 24, 0,  0  ] ]
  [ 'add-column-button-selected', [ 35, 24, 0,  24 ] ]
  [ 'add-row-button',             [ 35, 24, 0,  48 ] ]
  [ 'add-row-button-selected',    [ 35, 34, 0,  72 ] ]
  [ 'open',                       [ 53, 25, 0,  96 ] ]
  [ 'open-selected',              [ 53, 25, 0, 147 ] ]
  [ 'save',                       [ 52, 25, 0, 122 ] ]
  [ 'save-selected',              [ 52, 25, 0, 172 ] ]
  [ 'add-sheet',                  [ 24, 24, 0, 197 ] ]
  [ 'add-sheet-selected',         [ 24, 24, 24,197 ] ]
  [ 'radix-area',                 [ 24, 25, 0, 221 ] ]
  [ 'new-sheet-area',             [ 96, 25, 0, 246 ] ]
]

_.forEach buttonsToCut, (buttonToCut) ->
  cutButton buttonToCut[0], buttonToCut[1]
