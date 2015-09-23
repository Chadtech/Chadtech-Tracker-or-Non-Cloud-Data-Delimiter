

  handleClickToolbar0: (event) ->

    mouseX = event.clientX
    mouseY = event.clientY

    toolbar0 = document.getElementById 'toolbar0'
    toolbar0 = toolbar0.getContext '2d', alpha: false

    _.forEach (_.keys buttonXBoundaries), (key) =>
      button = buttonXBoundaries[ key ]
      if (mouseX > button[0]) and (button[1] > mouseX)
        @buttonToFunction toolbar0, key, event.type



  buttonToFunction: (ctx, button, direction) ->
    switch direction
      
      when 'mouseup'
        switch button
          
          when 'save'
            buttonFunctions.save.up ctx, @handleSave, @handleSaveAs, @state.filePath
      
          when 'open'
            buttonFunctions.open.up ctx, @handleOpen

      when 'mousedown'
        switch button
          
          when 'save'
            buttonFunctions.save.down ctx

          when 'open'
            buttonFunctions.open.down ctx


