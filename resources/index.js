(function() {
  var AllCharacters, AssetLoader, Assets, ConvertToCSV, CoordinateIsElement, DrawColumnNames, DrawColumnOptions, DrawEveryCell, DrawOriginMark, DrawRowNames, DrawRowOptions, DrawSelectedCell, Index, Keys, LoadGlyphs, React, _, a, borderGray, canvas, cell, darkGray, darkerGray, div, drawText, glyphs, gray, gui, hexToArray, img, injectionPoint, input, lighterGray, p, putPixel, ref, ref1, toolbarSize;

  global.document = window.document;

  global.navigator = window.navigator;

  React = require('react');

  _ = require('lodash');

  gui = require('nw.gui');

  ref = React.DOM, p = ref.p, a = ref.a, div = ref.div, input = ref.input, img = ref.img, canvas = ref.canvas;

  ref1 = require('./drawingUtilities.js'), putPixel = ref1.putPixel, hexToArray = ref1.hexToArray, drawText = ref1.drawText;

  CoordinateIsElement = require('./coordinate-in-array.js');

  ConvertToCSV = require('./convert-sheets-to-csvs.js');

  LoadGlyphs = require('./load-glyphs.js');

  AssetLoader = require('./load-assets.js');

  AllCharacters = require('./all-characters.js');

  Keys = require('./keys.js');

  DrawColumnNames = require('./draw-column-names.js');

  DrawRowNames = require('./draw-row-names.js');

  DrawEveryCell = require('./draw-every-cell.js');

  DrawSelectedCell = require('./draw-selected-cell.js');

  DrawColumnOptions = require('./draw-column-options.js');

  DrawRowOptions = require('./draw-row-options.js');

  DrawOriginMark = require('./draw-origin-mark.js');

  lighterGray = '#c0c0c0';

  gray = '#808080';

  darkGray = '#404040';

  darkerGray = '#202020';

  borderGray = '#101408';

  glyphs = LoadGlyphs(AllCharacters);

  glyphs.characterWidth = 11;

  glyphs.characterHeight = 19;

  toolbarSize = 52;

  cell = {
    w: 6 + (glyphs.characterWidth * 5),
    h: 7 + glyphs.characterHeight
  };

  Assets = AssetLoader();

  Index = React.createClass({
    getInitialState: function() {
      return {
        windowWidth: window.innerWidth,
        windowHeight: window.innerHeight,
        workareaHeight: window.innerHeight - (2 * (toolbarSize + 5)),
        sheets: [[['34', '32', '31', '32', '34'], ['32', '30', '31', '30', '32'], ['B', '', 'S', 'S', ''], ['Loud', '', 'Quiet', '', '']]],
        sheetNames: ['dollars'],
        selectedCells: [[2, 1]],
        currentSheet: 0,
        rowNameRadix: 8,
        commandIsDown: false,
        filePath: ''
      };
    },
    componentDidMount: function() {
      var fileExporter, nwDir;
      gui.Window.get().on('resize', this.handleResize);
      document.addEventListener('keyup', this.onKeyUp);
      document.addEventListener('keydown', this.onKeyDown);
      this.setCanvasDimensions();
      this.drawToolBar0();
      this.drawToolBar1();
      setTimeout(this.refreshWorkArea, 3000);
      fileExporter = document.getElementById('fileExporter');
      nwDir = window.document.createAttribute('nwdirectory');
      return fileExporter.setAttributeNode(nwDir);
    },
    setCanvasDimensions: function() {
      var toolbar0, toolbar1, workarea;
      toolbar0 = document.getElementById('toolbar0');
      toolbar0.width = this.state.windowWidth;
      toolbar0.height = toolbarSize;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1.width = this.state.windowHeight;
      toolbar1.height = toolbarSize;
      workarea = document.getElementById('workarea');
      workarea.width = this.state.windowWidth;
      workarea.height = this.state.windowHeight - (2 * (toolbarSize + 5));
      return this.refreshWorkArea();
    },
    handleResize: function() {
      return this.setState({
        windowWidth: window.innerWidth
      }, (function(_this) {
        return function() {
          return _this.setState({
            windowHeight: window.innerHeight
          }, function() {
            _this.setCanvasDimensions();
            _this.drawToolBar0();
            return _this.drawToolBar1();
          });
        };
      })(this));
    },
    drawToolBar0: function() {
      var borderColor, i, point, ref2, results, toolbar0;
      toolbar0 = document.getElementById('toolbar0');
      toolbar0 = toolbar0.getContext('2d');
      results = [];
      for (point = i = 0, ref2 = this.state.windowWidth - 1; 0 <= ref2 ? i <= ref2 : i >= ref2; point = 0 <= ref2 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        results.push(putPixel(toolbar0, borderColor, [point, toolbarSize - 1]));
      }
      return results;
    },
    drawToolBar1: function() {
      var borderColor, i, point, ref2, results, toolbar1;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1 = toolbar1.getContext('2d');
      results = [];
      for (point = i = 0, ref2 = this.state.windowWidth - 1; 0 <= ref2 ? i <= ref2 : i >= ref2; point = 0 <= ref2 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        results.push(putPixel(toolbar1, borderColor, [point, 0]));
      }
      return results;
    },
    refreshWorkArea: function() {
      var cellColor, currentSheet, edgeColor, i, len, ref2, results, selectedCell, selectedColor, sheetName, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      currentSheet = this.state.sheets[this.state.currentSheet];
      sheetName = this.state.sheetNames[this.state.currentSheet];
      cellColor = hexToArray(darkGray);
      edgeColor = hexToArray(darkerGray);
      selectedColor = hexToArray(lighterGray);
      DrawOriginMark(currentSheet, workarea, glyphs, edgeColor, cell, sheetName);
      DrawColumnNames(currentSheet, workarea, glyphs, edgeColor, cell);
      DrawRowNames(currentSheet, workarea, glyphs, edgeColor, cell);
      DrawEveryCell(currentSheet, workarea, glyphs, cellColor, cell);
      DrawColumnOptions(currentSheet, workarea, glyphs, edgeColor, cell, Assets);
      DrawRowOptions(currentSheet, workarea, glyphs, edgeColor, cell, Assets);
      ref2 = this.state.selectedCells;
      results = [];
      for (i = 0, len = ref2.length; i < len; i++) {
        selectedCell = ref2[i];
        results.push(DrawSelectedCell(currentSheet, workarea, glyphs, selectedColor, cell, selectedCell));
      }
      return results;
    },
    handleClickWorkArea: function(event) {
      var mouseX, mouseY, whichCell;
      mouseX = event.clientX;
      mouseY = event.clientY;
      mouseX -= cell.w;
      mouseY -= cell.h;
      mouseY -= toolbarSize + 5;
      whichCell = [(Math.floor(mouseY / cell.h)) - 1, (Math.floor(mouseX / cell.w)) - 1];
      if (!this.state.commandIsDown) {
        if (!((whichCell[0] < 0) || (whichCell[1] < 0))) {
          return this.setState({
            selectedCells: [whichCell]
          }, (function(_this) {
            return function() {
              return _this.refreshWorkArea();
            };
          })(this));
        }
      } else {
        if (!CoordinateIsElement(this.state.selectedCells, whichCell)) {
          this.state.selectedCells.push(whichCell);
          return this.setState({
            selectedCells: this.state.selectedCells
          }, (function(_this) {
            return function() {
              return _this.refreshWorkArea();
            };
          })(this));
        }
      }
    },
    handleSaveAs: function() {
      var csvs, fileExporter;
      csvs = ConvertToCSV(this.state.sheets);
      csvs = _.map(csvs, function(csv) {
        return new Buffer(csv, 'utf-8');
      });
      fileExporter = document.getElementById('fileExporter');
      fileExporter.addEventListener('change', (function(_this) {
        return function(event) {
          _this.setState({
            filePath: event.target.value
          });
          return _.forEach(csvs, function(csv, csvIndex) {
            var fileName, filePath;
            filePath = event.target.value;
            fileName = '/' + _this.state.sheetNames[csvIndex];
            fileName += '.csv';
            filePath += fileName;
            return fs.writeFileSync(filePath, csv);
          });
        };
      })(this));
      return fileExporter.click();
    },
    handleSave: function() {
      var csvs;
      csvs = ConvertToCSV(this.state.sheets);
      csvs = _.map(csvs, function(csv) {
        return new Buffer(csv, 'utf-8');
      });
      return _.forEach(csvs, (function(_this) {
        return function(csv, csvIndex) {
          var fileName, filePath;
          filePath = _this.state.filePath;
          fileName = '/' + _this.state.sheetNames[csvIndex];
          fileName += '.csv';
          filePath += fileName;
          return fs.writeFileSync(filePath, csv);
        };
      })(this));
    },
    onKeyUp: function(event) {
      if (event.which === Keys['command']) {
        return this.setState({
          commandIsDown: false
        }, function() {
          return console.log('command is marked Up');
        });
      }
    },
    onKeyDown: function(event) {
      if (event.which === Keys['command']) {
        this.setState({
          commandIsDown: true
        }, function() {
          return console.log('command is marked down');
        });
      }
      if (event.which === Keys['s']) {
        if (this.state.filePath) {
          return this.handleSave();
        } else {
          return this.handleSaveAs();
        }
      }
    },
    render: function() {
      return div({
        style: {
          backgroundColor: darkerGray,
          width: '100%',
          height: '100%',
          margin: 0,
          padding: 0,
          position: 'absolute',
          top: 0,
          left: 0
        }
      }, canvas({
        id: 'toolbar0',
        style: {
          backgroundColor: darkerGray,
          width: '100%',
          height: toolbarSize,
          imageRendering: 'pixelated'
        }
      }), canvas({
        id: 'toolbar1',
        style: {
          backgroundColor: darkerGray,
          position: 'absolute',
          top: this.state.windowHeight - toolbarSize,
          left: 0,
          width: '100%',
          height: toolbarSize,
          imageRendering: 'pixelated'
        }
      }), canvas({
        id: 'workarea',
        onMouseDown: this.handleClickWorkArea,
        style: {
          backgroundColor: '#000000',
          position: 'absolute',
          top: toolbarSize + 5,
          left: 0,
          width: '100%',
          height: this.state.workareaHeight,
          imageRendering: 'pixelated'
        }
      }));
    }
  });

  Index = React.createElement(Index);

  injectionPoint = document.getElementById('content');

  React.render(Index, injectionPoint);

}).call(this);
