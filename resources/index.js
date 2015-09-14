(function() {
  var AllCharacters, AssetLoader, Assets, CoordinateIsElement, DrawColumnNames, DrawColumnOptions, DrawEveryCell, DrawNormalCell, DrawOriginMark, DrawRowNames, DrawRowOptions, DrawSelectedCell, DrawSheetTabs, Glyphs, Index, Keys, LoadGlyphs, React, Sheets, _, a, borderGray, canvas, cell, cellColor, convertToCSVs, currentSheet, darkGray, darkerGray, div, doNothing, drawText, edgeColor, gray, gui, hexToArray, img, injectionPoint, input, justSelected, lighterGray, p, putPixel, ref, ref1, ref2, selectedCells, selectedColor, sheetNames, toolbarSize, zeroPadder;

  global.document = window.document;

  global.navigator = window.navigator;

  React = require('react');

  _ = require('lodash');

  gui = require('nw.gui');

  ref = React.DOM, p = ref.p, a = ref.a, div = ref.div, input = ref.input, img = ref.img, canvas = ref.canvas;

  ref1 = require('./drawingUtilities.js'), putPixel = ref1.putPixel, hexToArray = ref1.hexToArray, drawText = ref1.drawText;

  CoordinateIsElement = require('./coordinate-in-array.js');

  ref2 = require('./general-utilities.js'), convertToCSVs = ref2.convertToCSVs, zeroPadder = ref2.zeroPadder, doNothing = ref2.doNothing;

  LoadGlyphs = require('./load-Glyphs.js');

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

  DrawSheetTabs = require('./draw-sheet-tabs.js');

  lighterGray = '#c0c0c0';

  gray = '#808080';

  darkGray = '#404040';

  darkerGray = '#202020';

  borderGray = '#101408';

  cellColor = hexToArray(darkGray);

  edgeColor = hexToArray(darkerGray);

  selectedColor = hexToArray(lighterGray);

  Glyphs = void 0;

  toolbarSize = 35;

  cell = {
    w: 6 + (11 * 5),
    h: 7 + 19
  };

  Assets = void 0;

  currentSheet = 0;

  sheetNames = ['dollars'];

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
      var init, next;
      init = (function(_this) {
        return function() {
          var fileExporter, nwDir;
          gui.Window.get().on('resize', _this.handleResize);
          document.addEventListener('keyup', _this.onKeyUp);
          document.addEventListener('keydown', _this.onKeyDown);
          _this.setCanvasDimensions();
          _this.drawToolBar0();
          _this.drawToolBar1();
          _this.refreshWorkArea();
          fileExporter = document.getElementById('fileExporter');
          nwDir = window.document.createAttribute('nwdirectory');
          return fileExporter.setAttributeNode(nwDir);
        };
      })(this);
      next = (function(_this) {
        return function() {
          return Assets = AssetLoader(init);
        };
      })(this);
      Glyphs = LoadGlyphs(AllCharacters, next);
      Glyphs.characterWidth = 11;
      return Glyphs.characterHeight = 19;
    },
    setCanvasDimensions: function() {
      var toolbar0, toolbar1, workarea;
      toolbar0 = document.getElementById('toolbar0');
      toolbar0.width = window.innerWidth;
      toolbar0.height = toolbarSize;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1.width = window.innerHeight;
      toolbar1.height = toolbarSize;
      workarea = document.getElementById('workarea');
      workarea.width = window.innerWidth;
      return workarea.height = window.innerHeight - (2 * toolbarSize);
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
      var borderColor, i, point, ref3, sheetXOrg, toolbar1;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1 = toolbar1.getContext('2d');
      for (point = i = 0, ref3 = this.state.windowWidth - 1; 0 <= ref3 ? i <= ref3 : i >= ref3; point = 0 <= ref3 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        putPixel(toolbar1, borderColor, [point, 0]);
      }
      sheetXOrg = 5;
      return _.forEach(Sheets, function(sheet, sheetIndex) {
        var j, k, ref4, ref5, sheetName, tabWidth;
        sheetName = sheetNames[sheetIndex];
        tabWidth = sheetName.length + 2;
        tabWidth *= Glyphs.characterWidth;
        toolbar1.fillStyle = '#202020';
        toolbar1.fillRect(sheetXOrg, 0, tabWidth, cell.h);
        for (point = j = 0, ref4 = cell.h - 1; 0 <= ref4 ? j <= ref4 : j >= ref4; point = 0 <= ref4 ? ++j : --j) {
          putPixel(toolbar1, [0, 0, 0, 255], [sheetXOrg, point]);
          putPixel(toolbar1, [0, 0, 0, 255], [sheetXOrg + tabWidth, point]);
        }
        for (point = k = 0, ref5 = tabWidth - 1; 0 <= ref5 ? k <= ref5 : k >= ref5; point = 0 <= ref5 ? ++k : --k) {
          putPixel(toolbar1, [0, 0, 0, 255], [sheetXOrg + point, cell.h - 1]);
        }
        return drawText(toolbar1, Glyphs);
      });
    },
    drawSelectedCellsNormal: function() {
      var i, len, results, selectedCell, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      results = [];
      for (i = 0, len = selectedCells.length; i < len; i++) {
        selectedCell = selectedCells[i];
        results.push(DrawNormalCell(Sheets[currentSheet], workarea, Glyphs, cellColor, cell, selectedCell));
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
        results.push(DrawSelectedCell(Sheets[currentSheet], workarea, Glyphs, selectedColor, cell, selectedCell));
      }
      return results;
    },
    refreshWorkArea: function() {
      var sheetName, workarea;
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      sheetName = this.state.sheetNames[this.state.currentSheet];
      workarea.fillStyle = '#202020';
      workarea.fillRect(0, 0, window.innerWidth, window.innerHeight);
      DrawOriginMark(sheetName, workarea, Glyphs, edgeColor, cell);
      DrawColumnNames(Sheets[currentSheet], workarea, Glyphs, edgeColor, cell);
      DrawRowNames(Sheets[currentSheet], workarea, Glyphs, edgeColor, cell);
      DrawEveryCell(Sheets[currentSheet], workarea, Glyphs, cellColor, cell);
      DrawColumnOptions(Sheets[currentSheet], workarea, Glyphs, edgeColor, cell, Assets);
      DrawRowOptions(Sheets[currentSheet], workarea, Glyphs, edgeColor, cell, Assets);
      return this.drawSelectedCellsSelected();
    },
    handleClickWorkArea: function(event) {
      var mouseX, mouseY, newColumn, thisColumn, whichCell, workarea;
      mouseX = event.clientX;
      mouseY = event.clientY;
      mouseX -= cell.w;
      mouseY -= cell.h;
      mouseY -= toolbarSize + 5;
      whichCell = [(Math.floor(mouseY / cell.h)) - 1, (Math.floor(mouseX / cell.w)) - 1];
      workarea = document.getElementById('workarea');
      workarea = workarea.getContext('2d');
      if (!event.metaKey) {
        if ((whichCell[0] < 0) || (whichCell[1] < 0)) {
          if (whichCell[0] === -1) {
            thisColumn = Sheets[currentSheet][whichCell[1]];
            this.drawSelectedCellsNormal();
            selectedCells = [];
            _.forEach(thisColumn, function(row, rowIndex) {
              return selectedCells.push([rowIndex, whichCell[1]]);
            });
            this.drawSelectedCellsSelected();
          }
          if (whichCell[0] === -2) {
            if ((mouseX % cell.w) < 35) {
              newColumn = [];
              _.forEach(Sheets[currentSheet][0], function(column) {
                return newColumn.push('');
              });
              Sheets[currentSheet].splice(whichCell[1], 0, newColumn);
              this.refreshWorkArea();
            } else {
              Sheets[currentSheet].splice(whichCell[1], 1);
              this.refreshWorkArea();
            }
          }
          if (whichCell[1] === -1) {
            this.drawSelectedCellsNormal();
            selectedCells = [];
            _.forEach(Sheets[currentSheet], function(column, columnIndex) {
              return selectedCells.push([whichCell[0], columnIndex]);
            });
            this.drawSelectedCellsSelected();
          }
          if (whichCell[1] === -2) {
            if (((mouseX + cell.w) % cell.w) < 35) {
              _.forEach(Sheets[currentSheet], function(column) {
                return column.splice(whichCell[0], 0, '');
              });
              return this.refreshWorkArea();
            } else {
              _.forEach(Sheets[currentSheet], function(column) {
                return column.splice(whichCell[0], 1);
              });
              return this.refreshWorkArea();
            }
          }
        } else {
          this.drawSelectedCellsNormal();
          selectedCells = [whichCell];
          this.drawSelectedCellsSelected();
          return justSelected = true;
        }
      } else {
        if (!CoordinateIsElement(selectedCells, whichCell)) {
          selectedCells.push(whichCell);
          return DrawSelectedCell(Sheets[currentSheet], workarea, Glyphs, selectedColor, cell, whichCell);
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
                return DrawSelectedCell(Sheets[currentSheet], workarea, Glyphs, selectedColor, cell, SC);
              } else {
                SC = selectedCells[0];
                Sheets[currentSheet][SC[1]][SC[0]] = '';
                return DrawSelectedCell(Sheets[currentSheet], workarea, Glyphs, selectedColor, cell, SC);
              }
              break;
            case Keys['enter']:
              justSelected = true;
              this.drawSelectedCellsNormal();
              selectedCells[0][0]++;
              return this.drawSelectedCellsSelected();
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
                return DrawSelectedCell(Sheets[currentSheet], workarea, Glyphs, selectedColor, cell, SC);
              } else {
                SC = selectedCells[0];
                Sheets[currentSheet][SC[1]][SC[0]] += Keys[event.which];
                return DrawSelectedCell(Sheets[currentSheet], workarea, Glyphs, selectedColor, cell, SC);
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
