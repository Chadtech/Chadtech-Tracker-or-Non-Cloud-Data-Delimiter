module.exports = (next) ->

  image = ->
    document.createElement 'IMG'

  assets = {}

  totalNumberOfAssets  = 10
  numberOfAssetsLoaded = 0

  checkForNext = (a, b, c, d) =>
    numberOfAssetsLoaded++
    if numberOfAssetsLoaded is totalNumberOfAssets
      next()

  load = (key, name) =>
    assets[ key ] = [ image(), image() ]
    assets[ key ][0].src    = './' + name + '.png'
    assets[ key ][0].onload = checkForNext
    assets[ key ][1].src    = './' + name + '-selected.png'
    assets[ key ][1].onload = checkForNext


  load 'X',              'x-button'
  load '<+',             'add-column-button'
  load '^+',             'add-row-button'
  load 'save',           'save'
  load 'open',           'open'
  load '+',              'add-sheet'
  # load 'radix-area',     'radix-area'
  # load 'new-sheet-area', 'new-sheet-area'

  assets