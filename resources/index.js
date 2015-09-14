(function() {
  var AllCharacters, AssetLoader, Assets, CoordinateIsElement, DrawColumnNames, DrawColumnOptions, DrawEveryCell, DrawNormalCell, DrawOriginMark, DrawRowNames, DrawRowOptions, DrawSelectedCell, Index, Keys, LoadGlyphs, React, Sheets, _, a, borderGray, canvas, cell, cellColor, convertToCSVs, currentSheet, darkGray, darkerGray, div, doNothing, drawText, edgeColor, glyphs, gray, gui, hexToArray, img, injectionPoint, input, justSelected, lighterGray, p, putPixel, ref, ref1, ref2, selectedCells, selectedColor, toolbarSize, zeroPadder;

  global.document = window.document;

  global.navigator = window.navigator;

  React = require('react');

  _ = require('lodash');

  gui = require('nw.gui');

  ref = React.DOM, p = ref.p, a = ref.a, div = ref.div, input = ref.input, img = ref.img, canvas = ref.canvas;

  ref1 = require('./drawingUtilities.js'), putPixel = ref1.putPixel, hexToArray = ref1.hexToArray, drawText = ref1.drawText;

  CoordinateIsElement = require('./coordinate-in-array.js');

  ref2 = require('./general-utilities.js'), convertToCSVs = ref2.convertToCSVs, zeroPadder = ref2.zeroPadder, doNothing = ref2.doNothing;

  LoadGlyphs = require('./load-glyphs.js');

  AssetLoader = require('./load-assets.js');

  AllCharacters = require('./all-characters.js');

  Keys = (function(Keys) {
    var output;
    output = {};
    _.forEach(_.keys(Keys), function(key) {
      return output[Keys[key]] = key;
    });
    _.forEach(_.keys(Keys), function(key) {
      return output[key] = Keys[key];
    });
    return output;
  })(require('./keys.js'));

  DrawColumnNames = require('./draw-column-names.js');

  DrawRowNames = require('./draw-row-names.js');

  DrawEveryCell = require('./draw-every-cell.js');

  DrawSelectedCell = require('./draw-selected-cell.js');

  DrawColumnOptions = require('./draw-column-options.js');

  DrawRowOptions = require('./draw-row-options.js');

  DrawOriginMark = require('./draw-origin-mark.js');

  DrawNormalCell = require('./draw-normal-cell.js');

  lighterGray = '#c0c0c0';

  gray = '#808080';

  darkGray = '#404040';

  darkerGray = '#202020';

  borderGray = '#101408';

  cellColor = hexToArray(darkGray);

  edgeColor = hexToArray(darkerGray);

  selectedColor = hexToArray(lighterGray);

  glyphs = LoadGlyphs(AllCharacters);

  glyphs.characterWidth = 11;

  glyphs.characterHeight = 19;

  toolbarSize = 35;

  cell = {
    w: 6 + (glyphs.characterWidth * 5),
    h: 7 + glyphs.characterHeight
  };

  Assets = AssetLoader();

  currentSheet = 0;

  Sheets = [[['34', '32', '31', '32', '34', '34', '32', '31', '32', '34'], ['32', '30', '31', '30', '32', '32', '30', '31', '30', '32'], ['B', '', 'S', 'S', '', 'B', '', 'S', 'S', ''], ['Loud', '', 'Quiet', '', '', 'Loud', '', 'Quiet', '', ''], ['34', '32', '31', '32', '34', '34', '32', '31', '32', '34'], ['32', '30', '31', '30', '32', '32', '30', '31', '30', '32'], ['B', '', 'S', 'S', '', 'B', '', 'S', 'S', ''], ['Loud', '', 'Quiet', '', '', 'Loud', '', 'Quiet', '', '']]];

  selectedCells = [[2, 3]];

  justSelected = true;

  Index = React.createClass({
    getInitialState: function() {
      return {
        windowWidth: window.innerWidth,
        windowHeight: window.innerHeight,
        workareaHeight: window.innerHeight - (2 * toolbarSize),
        sheetNames: ['dollars'],
        currentSheet: 0,
        rowNameRadix: 8,
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
      setTimeout(this.refreshWorkArea, 5000);
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
      return workarea.height = this.state.windowHeight - (2 * (toolbarSize + 5));
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
      var borderColor, i, point, ref3, toolbar0;
      toolbar0 = document.getElementById('toolbar0');
      toolbar0 = toolbar0.getContext('2d');
      for (point = i = 0, ref3 = this.state.windowWidth - 1; 0 <= ref3 ? i <= ref3 : i >= ref3; point = 0 <= ref3 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        putPixel(toolbar0, borderColor, [point, toolbarSize - 1]);
      }
      toolbar0.drawImage(Assets['open'][0], 5, 5);
      return toolbar0.drawImage(Assets['save'][0], 58, 5);
    },
    drawToolBar1: function() {
      var borderColor, i, point, ref3, results, toolbar1;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1 = toolbar1.getContext('2d');
      results = [];
      for (point = i = 0, ref3 = this.state.windowWidth - 1; 0 <= ref3 ? i <= ref3 : i >= ref3; point = 0 <= ref3 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        results.push(putPixel(toolbar1, borderColor, [point, 0]));
      }
      return results;
    },
    drawSelectedCellsNormal: function() {
      var i, len, results, selectedCell, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      results = [];
      for (i = 0, len = selectedCells.length; i < len; i++) {
        selectedCell = selectedCells[i];
        results.push(DrawNormalCell(Sheets[currentSheet], workarea, glyphs, cellColor, cell, selectedCell));
      }
      return results;
    },
    drawSelectedCellsSelected: function() {
      var i, len, results, selectedCell, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      results = [];
      for (i = 0, len = selectedCells.length; i < len; i++) {
        selectedCell = selectedCells[i];
        results.push(DrawSelectedCell(Sheets[currentSheet], workarea, glyphs, selectedColor, cell, selectedCell));
      }
      return results;
    },
    refreshWorkArea: function() {
      var sheetName, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      sheetName = this.state.sheetNames[this.state.currentSheet];
      DrawOriginMark(sheetName, workarea, glyphs, edgeColor, cell);
      DrawColumnNames(Sheets[currentSheet], workarea, glyphs, edgeColor, cell);
      DrawRowNames(Sheets[currentSheet], workarea, glyphs, edgeColor, cell);
      DrawEveryCell(Sheets[currentSheet], workarea, glyphs, cellColor, cell);
      DrawColumnOptions(Sheets[currentSheet], workarea, glyphs, edgeColor, cell, Assets);
      DrawRowOptions(Sheets[currentSheet], workarea, glyphs, edgeColor, cell, Assets);
      return this.drawSelectedCellsSelected();
    },
    handleClickWorkArea: function(event) {
      var mouseX, mouseY, whichCell, workarea;
      mouseX = event.clientX;
      mouseY = event.clientY;
      mouseX -= cell.w;
      mouseY -= cell.h;
      mouseY -= toolbarSize + 5;
      whichCell = [(Math.floor(mouseY / cell.h)) - 1, (Math.floor(mouseX / cell.w)) - 1];
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      if (!event.metaKey) {
        if (!((whichCell[0] < 0) || (whichCell[1] < 0))) {
          this.drawSelectedCellsNormal();
          selectedCells = [whichCell];
          this.drawSelectedCellsSelected();
          return justSelected = true;
        }
      } else {
        if (!CoordinateIsElement(selectedCells, whichCell)) {
          selectedCells.push(whichCell);
          return DrawSelectedCell(Sheets[currentSheet], workarea, glyphs, selectedColor, cell, whichCell);
        }
      }
    },
    handleSaveAs: function() {
      var csvs, fileExporter;
      csvs = convertToCSVs(this.state.sheets);
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
      csvs = convertToCSVs(this.state.sheets);
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
    onKeyUp: function(event) {},
    onKeyDown: function(event) {
      var SC, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      if (event.metaKey) {
        if (event.which === Keys['s']) {
          if (this.state.filePath) {
            return this.handleSave();
          } else {
            return this.handleSaveAs();
          }
        }
      } else {
        if (selectedCells.length === 1) {
          switch (event.which) {
            case Keys['backspace']:
              if (justSelected) {
                justSelected = false;
                SC = selectedCells[0];
                Sheets[currentSheet][SC[1]][SC[0]] = '';
                return DrawSelectedCell(Sheets[currentSheet], workarea, glyphs, selectedColor, cell, SC);
              } else {
                SC = selectedCells[0];
                Sheets[currentSheet][SC[1]][SC[0]] = '';
                return DrawSelectedCell(Sheets[currentSheet], workarea, glyphs, selectedColor, cell, SC);
              }
              break;
            case Keys['down']:
              justSelected = true;
              this.drawSelectedCellsNormal();
              selectedCells[0][0]++;
              return this.drawSelectedCellsSelected();
            case Keys['up']:
              justSelected = true;
              this.drawSelectedCellsNormal();
              selectedCells[0][0]--;
              return this.drawSelectedCellsSelected();
            case Keys['right']:
              justSelected = true;
              this.drawSelectedCellsNormal();
              selectedCells[0][1]++;
              return this.drawSelectedCellsSelected();
            case Keys['left']:
              justSelected = true;
              this.drawSelectedCellsNormal();
              selectedCells[0][1]--;
              return this.drawSelectedCellsSelected();
            case Keys['ctrl']:
              return doNothing();
            case Keys['shift']:
              return doNothing();
            default:
              if (justSelected) {
                justSelected = false;
                SC = selectedCells[0];
                Sheets[currentSheet][SC[1]][SC[0]] = Keys[event.which];
                return DrawSelectedCell(Sheets[currentSheet], workarea, glyphs, selectedColor, cell, SC);
              } else {
                SC = selectedCells[0];
                Sheets[currentSheet][SC[1]][SC[0]] += Keys[event.which];
                return DrawSelectedCell(Sheets[currentSheet], workarea, glyphs, selectedColor, cell, SC);
              }
          }
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
          backgroundColor: darkerGray,
          position: 'absolute',
          top: toolbarSize,
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
