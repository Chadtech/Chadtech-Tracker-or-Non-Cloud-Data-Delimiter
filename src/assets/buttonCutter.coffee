fs = require 'fs'
gm = require 'gm'

destination = './../../resources/'

xButton = gm './buttonSprites.png'
xButton.crop 25, 24, 35, 0
xButton.write destination + 'x-button.png', (err) ->
  if err
    console.log err

xButtonSelected = gm './buttonSprites.png'
xButtonSelected.crop 25, 24, 35, 24
fileName = destination + 'x-button-selected.png'
xButtonSelected.write fileName, (err) ->
  if err
    console.log err

addColumnButton = gm './buttonSprites.png'
addColumnButton.crop 35, 24, 0, 0
fileName = destination + 'add-column-button.png'
addColumnButton.write fileName, (err) ->
  if err
    console.log err

addColumnButtonSelected = gm './buttonSprites.png'
addColumnButtonSelected.crop 35, 24, 0, 24
fileName = destination + 'add-column-button-selected.png'
addColumnButtonSelected.write fileName, (err) ->
  if err
    console.log err

addColumnButtonSelected = gm './buttonSprites.png'
addColumnButtonSelected.crop 35, 24, 0, 48
fileName = destination + 'add-row-button.png'
addColumnButtonSelected.write fileName, (err) ->
  if err
    console.log err

addColumnButtonSelected = gm './buttonSprites.png'
addColumnButtonSelected.crop 35, 24, 0, 72
fileName = destination + 'add-row-button-selected.png'
addColumnButtonSelected.write fileName, (err) ->
  if err
    console.log err