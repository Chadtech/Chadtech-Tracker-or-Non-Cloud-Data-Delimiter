fs = require 'fs'
gm = require 'gm'

destination = './../../resources/'

img = gm './buttonSprites.png'
img.crop 25, 24, 35, 0
img.write destination + 'x-button.png', (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 25, 24, 35, 24
fileName = destination + 'x-button-selected.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 35, 24, 0, 0
fileName = destination + 'add-column-button.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 35, 24, 0, 24
fileName = destination + 'add-column-button-selected.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 35, 24, 0, 48
fileName = destination + 'add-row-button.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 35, 24, 0, 72
fileName = destination + 'add-row-button-selected.png'
img.write fileName, (err) ->
  if err
    console.log err