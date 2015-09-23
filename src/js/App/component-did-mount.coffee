Index = React.createClass


  getInitialState: ->
    windowWidth:    window.innerWidth
    windowHeight:   window.innerHeight
    workareaHeight: window.innerHeight - (2 * toolbarSize)
    filePath:       ''


  componentDidMount: ->

    WorkArea document

    init = =>

      _.forEach [ 0 .. 4 ], ( CS ) ->
        thisScheme = Glyphs.images[ CS ]
        _.forEach (_.keys thisScheme), (key) ->
          character = thisScheme[ key ]

          glyphCanvas = document.createElement 'canvas'
          glyphCanvas.width   = 11
          glyphCanvas.height  = 19
          glyphCtx = glyphCanvas.getContext '2d'
          glyphCtx.drawImage character, 0, 0

          thisScheme[ key ] = glyphCanvas

        Glyphs.images[ CS ] = thisScheme

      document.addEventListener 'keyup',   @onKeyUp
      document.addEventListener 'keydown', @onKeyDown

      @setCanvasDimensions()
      @drawToolBar0()
      @drawToolBar1()
      @refreshWorkArea()

      fileExporter = document.getElementById 'fileExporter'
      nwDir        = window.document.createAttribute 'nwdirectory'
      fileExporter.setAttributeNode nwDir

      fileImporter = document.getElementById 'fileImporter'
      nwDir        = window.document.createAttribute 'nwdirectory'
      fileImporter.setAttributeNode nwDir

    next = =>
      Assets = AssetLoader init

    Glyphs                 = LoadGlyphs AllCharacters, next
    Glyphs.characterWidth  = 11
    Glyphs.characterHeight = 19