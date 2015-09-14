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

img = gm './buttonSprites.png'
img.crop 53, 25, 0, 96
fileName = destination + 'open.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 53, 25, 0, 147
fileName = destination + 'open-selected.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 52, 25, 0, 122
fileName = destination + 'save.png'
img.write fileName, (err) ->
  if err
    console.log err

img = gm './buttonSprites.png'
img.crop 52, 25, 0, 172
fileName = destination + 'save-selected.png'
img.write fileName, (err) ->
  if err
    console.log err

