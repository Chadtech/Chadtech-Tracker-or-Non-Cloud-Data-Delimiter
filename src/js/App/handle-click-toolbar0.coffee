
  # buttonFunctions:
  #   open: doNothing
  #   save: 
  #     mouseDown: (toolbar0) =>
  #       toolbar0.drawImage Assets['save'][1], 57, 5

  #     mouseUp: (toolbar0, handleSave, handleSaveAs, stateFilePath) =>
  #       if stateFilePath isnt ''
  #         handleSave()
  #       else
  #         @handleSaveAs()
  #       toolbar0.drawImage Assets['save'][0], 57, 5


  # handleClickToolbar0: ->
  #   mouseX = event.clientX
  #   mouseY = event.clientY
    
  #   toolbar0 = document.getElementById 'toolbar0'
  #   toolbar0 = toolbar0.getContext '2d', alpha: false

  #   buttonXBoundaries =
  #     'open': [ 5, 56 ]
  #     'save': [ 57, 109 ]

  #   _.forEach (_.keys buttonXBoundaries), (key) =>
  #     button = buttonXBoundaries[ key ]
  #     if (mouseX > button[0]) and (button[1] > mouseX)
  #       @buttonFunctions[key].mouseDown toolbar0


  handleMouseUpToolbar0: ->
    mouseX = event.clientX
    mouseY = event.clientY

    buttonXBoundaries =
      'open': [ 5, 56 ]
      'save': [ 57, 109 ]

    _.forEach (_.keys buttonXBoundaries), (key) =>
      button = buttonXBoundaries[ key ]
      if (mouseX > button[0]) and (button[1] > mouseX)
        @buttonFunctions[key].mouseUp toolbar0, 
          @handleSave
          @handleSaveAs
          @state.filePath