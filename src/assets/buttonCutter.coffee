fs = require 'fs'
gm = require 'gm'

destination = './../../resources/'

xButton = gm './buttonSprites.png'
xButton.crop 24, 24, 34, 0
xButton.write destination + 'x-button.png', (err) ->
  if err
    console.log err

xButtonSelected = gm './buttonSprites.png'
xButtonSelected.crop 24, 24, 34, 25
fileName = destination + 'x-button-selected.png'
xButtonSelected.write fileName, (err) ->
  if err
    console.log err

addColumnButton = gm './buttonSprites.png'
addColumnButton.crop 32, 24, 1, 0
fileName = destination + 'add-column-button.png'
addColumnButton.write fileName, (err) ->
  if err
    console.log err

addColumnButtonSelected = gm './buttonSprites.png'
addColumnButtonSelected.crop 32, 24, 1, 25
fileName = destination +  'add-column-button-selected.png'
addColumnButtonSelected.write fileName, (err) ->
  if err
    console.log err