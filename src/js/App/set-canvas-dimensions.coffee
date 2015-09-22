  setCanvasDimensions: ->
    toolbar0        = document.getElementById 'toolbar0'
    toolbar0.width  = window.innerWidth
    toolbar0.height = toolbarSize

    toolbar1        = document.getElementById 'toolbar1'
    toolbar1.width  = window.innerWidth
    toolbar1.height = toolbarSize

    workarea        = document.getElementById 'workarea'
    workarea.width  = window.innerWidth
    workarea.height = window.innerHeight - (2 * toolbarSize)

