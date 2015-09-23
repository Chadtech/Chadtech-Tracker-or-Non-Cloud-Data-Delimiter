module.exports = (next) ->

  image = ->
    document.createElement 'IMG'

  assets = {}

  totalNumberOfAssets  = 14
  numberOfAssetsLoaded = 0

  checkForNext = (a, b, c, d) =>
    numberOfAssetsLoaded++
    if numberOfAssetsLoaded is totalNumberOfAssets
      next()

  load = (key, name, selectedImage) =>
    assets[ key ] = [ image(), image() ]
    assets[ key ][0].src    = './' + name + '.png'
    assets[ key ][0].onload = checkForNext
    if selectedImage
      assets[ key ][1].src    = './' + name + '-selected.png'
      assets[ key ][1].onload = checkForNext


  load 'X',              'x-button',          true
  load '<+',             'add-column-button', true
  load '^+',             'add-row-button',    true
  load 'save',           'save',              true
  load 'open',           'open',              true
  load '+',              'add-sheet',         true
  load 'radix-area',     'radix-area',        false
  load 'new-sheet-area', 'new-sheet-area',    false

  assets