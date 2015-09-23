(function() {
  var AllCharacters, AssetLoader, Assets, ClearAllCellGlyphs, CoordinateIsElement, DrawColumnBoxes, DrawColumnNames, DrawColumnOptions, DrawEveryCell, DrawEveryCellBorder, DrawEveryCellData, DrawNormalCell, DrawOriginMark, DrawRowBoxes, DrawRowNames, DrawRowOptions, DrawSelectedCell, DrawSheetTabs, Eightx15ify, Glyphs, Index, Keys, LoadGlyphs, React, Sheets, WorkArea, _, borderColor, borderGray, buttonXBoundaries, canvas, cell, cellColor, cellXOrg, cellYOrg, convertToCSVs, currentSheet, darkGray, darkerGray, div, doNothing, drawText, edgeColor, gray, gui, hexToArray, injectionPoint, input, justSelected, lighterGray, putPixel, ref, ref1, ref2, rowNameRadix, selectedCells, selectedColor, sheetNames, toolbarSize, topEdgeColor, zeroPadder;

  global.document = window.document;

  global.navigator = window.navigator;

  React = require('react');

  _ = require('lodash');

  gui = require('nw.gui');

  ref = React.DOM, div = ref.div, input = ref.input, canvas = ref.canvas;

  ref1 = require('./drawingUtilities.js'), putPixel = ref1.putPixel, hexToArray = ref1.hexToArray, drawText = ref1.drawText;

  CoordinateIsElement = require('./coordinate-in-array.js');

  ref2 = require('./general-utilities.js'), convertToCSVs = ref2.convertToCSVs, zeroPadder = ref2.zeroPadder, doNothing = ref2.doNothing, Eightx15ify = ref2.Eightx15ify;

  WorkArea = function(doc) {
    WorkArea = doc.getElementById('workarea');
    return WorkArea = WorkArea.getContext('2d', {
      alpha: false
    });
  };

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

  DrawEveryCell = require('./draw-every-cell.js');

  DrawSelectedCell = require('./draw-selected-cell.js');

  DrawColumnOptions = require('./draw-column-options.js');

  DrawColumnNames = require('./draw-column-names.js');

  DrawColumnBoxes = require('./draw-column-boxes.js');

  DrawRowOptions = require('./draw-row-options.js');

  DrawRowNames = require('./draw-row-names.js');

  DrawRowBoxes = require('./draw-row-boxes.js');

  DrawOriginMark = require('./draw-origin-mark.js');

  DrawNormalCell = require('./draw-normal-cell.js');

  DrawSheetTabs = require('./draw-sheet-tabs.js');

  DrawEveryCellBorder = require('./draw-every-cell-border.js');

  DrawEveryCellData = require('./draw-every-cell-data.js');

  ClearAllCellGlyphs = require('./clear-all-cell-glyphs.js');

  lighterGray = '#c0c0c0';

  gray = '#808080';

  darkGray = '#404040';

  darkerGray = '#202020';

  borderGray = '#101010';

  cellColor = hexToArray(darkGray);

  edgeColor = hexToArray(darkerGray);

  selectedColor = hexToArray(lighterGray);

  borderColor = hexToArray(borderGray);

  topEdgeColor = hexToArray(gray);

  Glyphs = void 0;

  toolbarSize = 35;

  cell = {
    w: 6 + (11 * 5),
    h: 7 + 19
  };

  Assets = void 0;

  buttonXBoundaries = {
    'open': [4, 55],
    'save': [56, 108]
  };

  currentSheet = 0;

  sheetNames = ['dollars', 'numbers'];

  Sheets = require('./initial-sheets.js');

  selectedCells = [[2, 3]];

  justSelected = true;

  cellXOrg = 0;

  cellYOrg = 0;

  rowNameRadix = 8;

  Index = React.createClass({
    getInitialState: function() {
      return {
        windowWidth: window.innerWidth,
        windowHeight: window.innerHeight,
        workareaHeight: window.innerHeight - (2 * toolbarSize),
        filePath: ''
      };
    },
    componentDidMount: function() {
      var init, next;
      WorkArea(document);
      init = (function(_this) {
        return function() {
          var fileExporter, nwDir;
          _.forEach([0, 1, 2, 3, 4], function(CS) {
            var thisScheme;
            thisScheme = Glyphs.images[CS];
            _.forEach(_.keys(thisScheme), function(key) {
              var character, glyphCanvas, glyphCtx;
              character = thisScheme[key];
              glyphCanvas = document.createElement('canvas');
              glyphCanvas.width = 11;
              glyphCanvas.height = 19;
              glyphCtx = glyphCanvas.getContext('2d');
              glyphCtx.drawImage(character, 0, 0);
              return thisScheme[key] = glyphCanvas;
            });
            return Glyphs.images[CS] = thisScheme;
          });
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
      toolbar1.width = window.innerWidth;
      toolbar1.height = toolbarSize;
      workarea = document.getElementById('workarea');
      workarea.width = window.innerWidth;
      return workarea.height = window.innerHeight - (2 * toolbarSize);
    },
    drawToolBar0: function() {
      var i, point, ref3, toolbar0;
      toolbar0 = document.getElementById('toolbar0');
      toolbar0 = toolbar0.getContext('2d');
      for (point = i = 0, ref3 = window.innerWidth - 1; 0 <= ref3 ? i <= ref3 : i >= ref3; point = 0 <= ref3 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        putPixel(toolbar0, cellColor, [point, toolbarSize - 2]);
      }
      toolbar0.drawImage(Assets['open'][0], 4, 4);
      return toolbar0.drawImage(Assets['save'][0], 57, 4);
    },
    drawToolBar1: function() {
      var i, point, ref3, sheetXOrg, toolbar1;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1 = toolbar1.getContext('2d');
      for (point = i = 0, ref3 = window.innerWidth - 1; 0 <= ref3 ? i <= ref3 : i >= ref3; point = 0 <= ref3 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        putPixel(toolbar1, borderColor, [point, 2]);
        putPixel(toolbar1, borderColor, [point, 3]);
      }
      sheetXOrg = 5;
      return _.forEach(Sheets, function(sheet, sheetIndex) {
        var glyphXOffset, glyphXOrg, j, k, l, m, ref4, ref5, ref6, ref7, sheetName, tabWidth;
        sheetName = sheetNames[sheetIndex];
        if (sheetIndex !== currentSheet) {
          tabWidth = 9 * Glyphs.characterWidth;
          toolbar1.fillStyle = '#202020';
          toolbar1.fillRect(sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1);
          for (point = j = 0, ref4 = tabWidth; 0 <= ref4 ? j <= ref4 : j >= ref4; point = 0 <= ref4 ? ++j : --j) {
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, 2]);
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, 3]);
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, cell.h + 2]);
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, cell.h + 3]);
          }
          for (point = k = 0, ref5 = cell.h - 1; 0 <= ref5 ? k <= ref5 : k >= ref5; point = 0 <= ref5 ? ++k : --k) {
            putPixel(toolbar1, cellColor, [sheetXOrg, point + 3]);
            putPixel(toolbar1, cellColor, [sheetXOrg - 1, point + 4]);
            putPixel(toolbar1, borderColor, [sheetXOrg + tabWidth - 1, point + 3]);
          }
          glyphXOrg = sheetXOrg;
          glyphXOffset = Math.floor(tabWidth / 2);
          glyphXOffset -= Math.floor((11 * sheetName.length) / 2);
          glyphXOrg += glyphXOffset;
          drawText(toolbar1, Glyphs, 6, sheetName, [glyphXOrg, 7]);
          return sheetXOrg += tabWidth + 4;
        } else {
          tabWidth = sheetName.length + 2;
          tabWidth *= Glyphs.characterWidth;
          toolbar1.fillStyle = '#202020';
          toolbar1.fillRect(sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1);
          for (point = l = 0, ref6 = tabWidth; 0 <= ref6 ? l <= ref6 : l >= ref6; point = 0 <= ref6 ? ++l : --l) {
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, cell.h + 2]);
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, cell.h + 3]);
          }
          for (point = m = 0, ref7 = cell.h - 1; 0 <= ref7 ? m <= ref7 : m >= ref7; point = 0 <= ref7 ? ++m : --m) {
            putPixel(toolbar1, cellColor, [sheetXOrg, point + 3]);
            putPixel(toolbar1, cellColor, [sheetXOrg - 1, point + 4]);
            putPixel(toolbar1, borderColor, [sheetXOrg + tabWidth - 1, point + 3]);
          }
          glyphXOrg = sheetXOrg;
          glyphXOffset = Math.floor(tabWidth / 2);
          glyphXOffset -= Math.floor((11 * sheetName.length) / 2);
          glyphXOrg += glyphXOffset;
          drawText(toolbar1, Glyphs, 6, sheetName, [glyphXOrg, 7]);
          return sheetXOrg += tabWidth + 4;
        }
      });
    },
    Just8x15: function() {
      return Eightx15ify(Sheets[currentSheet], cellXOrg, cellYOrg);
    },
    DrawSelectedCellsNormal: function() {
      var i, len, results, selectedCell;
      results = [];
      for (i = 0, len = selectedCells.length; i < len; i++) {
        selectedCell = selectedCells[i];
        results.push(DrawNormalCell(this.Just8x15(), WorkArea, Glyphs, cellColor, cell, selectedCell));
      }
      return results;
    },
    DrawSelectedCellsSelected: function() {
      var i, len, results, selectedCell;
      results = [];
      for (i = 0, len = selectedCells.length; i < len; i++) {
        selectedCell = selectedCells[i];
        results.push(DrawSelectedCell(this.Just8x15(), WorkArea, Glyphs, selectedColor, cell, selectedCell));
      }
      return results;
    },
    DrawSelectedCell: function(selectedCell) {
      return DrawSelectedCell(this.Just8x15(), WorkArea, Glyphs, selectedColor, cell, selectedCell);
    },
    ClearAllCellGlyphs: function() {
      return ClearAllCellGlyphs(WorkArea, Glyphs, cellColor, cell);
    },
    DrawEveryCellData: function() {
      return DrawEveryCellData(this.Just8x15(), WorkArea, Glyphs, cellColor, cell);
    },
    DrawRowNames: function() {
      return DrawRowNames(this.Just8x15(), WorkArea, Glyphs, edgeColor, cell, cellYOrg, rowNameRadix);
    },
    DrawRowBoxes: function() {
      return DrawRowBoxes(WorkArea, edgeColor, cell);
    },
    DrawColumnNames: function() {
      return DrawColumnNames(this.Just8x15(), WorkArea, Glyphs, edgeColor, cell, cellXOrg);
    },
    DrawColumnBoxes: function() {
      return DrawColumnBoxes(WorkArea, edgeColor, cell);
    },
    refreshWorkArea: function() {
      var sheetName;
      sheetName = sheetNames[currentSheet];
      WorkArea.fillStyle = '#000000';
      WorkArea.fillRect(0, 0, window.innerWidth, window.innerHeight);
      DrawOriginMark(sheetName, WorkArea, Glyphs, edgeColor, cell, Assets);
      this.DrawColumnBoxes();
      this.DrawColumnNames();
      this.DrawRowBoxes();
      this.DrawRowNames();
      this.ClearAllCellGlyphs();
      DrawEveryCellBorder(Sheets[currentSheet], WorkArea, Glyphs, cellColor, cell);
      this.DrawEveryCellData();
      DrawColumnOptions(Sheets[currentSheet], WorkArea, Glyphs, edgeColor, cell, Assets);
      DrawRowOptions(Sheets[currentSheet], WorkArea, Glyphs, edgeColor, cell, Assets);
      return this.DrawSelectedCellsSelected();
    },
    handleClickWorkArea: function(event) {
      var mouseX, mouseY, newColumn, thisColumn, whichCell;
      mouseX = event.clientX;
      mouseY = event.clientY;
      mouseX -= cell.w;
      mouseY -= cell.h;
      mouseY -= toolbarSize + 5;
      whichCell = [(Math.floor((mouseY + 6) / cell.h)) - 1, (Math.floor(mouseX / cell.w)) - 1];
      if (!event.metaKey) {
        if ((whichCell[0] < 0) || (whichCell[1] < 0)) {
          if (whichCell[0] === -1) {
            thisColumn = Sheets[currentSheet][whichCell[1]];
            this.DrawSelectedCellsNormal();
            selectedCells = [];
            _.forEach(thisColumn, function(row, rowIndex) {
              return selectedCells.push([rowIndex, whichCell[1]]);
            });
            this.DrawSelectedCellsSelected();
          }
          if (whichCell[0] === -2) {
            if ((mouseX % cell.w) < 25) {
              Sheets[currentSheet].splice(whichCell[1], 1);
              this.ClearAllCellGlyphs();
              this.DrawEveryCellData();
            } else {
              newColumn = [];
              _.forEach(Sheets[currentSheet][0], function(column) {
                return newColumn.push('');
              });
              Sheets[currentSheet].splice(whichCell[1] + 1, 0, newColumn);
              this.ClearAllCellGlyphs();
              this.DrawEveryCellData();
            }
          }
          if (whichCell[1] === -1) {
            this.DrawSelectedCellsNormal();
            selectedCells = [];
            _.forEach(Sheets[currentSheet], function(column, columnIndex) {
              return selectedCells.push([whichCell[0], columnIndex]);
            });
            this.DrawSelectedCellsSelected();
          }
          if (whichCell[1] === -2) {
            if (((mouseX + cell.w) % cell.w) < 25) {
              _.forEach(Sheets[currentSheet], function(column) {
                return column.splice(whichCell[0], 1);
              });
              this.ClearAllCellGlyphs();
              return this.DrawEveryCellData();
            } else {
              _.forEach(Sheets[currentSheet], function(column) {
                return column.splice(whichCell[0] + 1, 0, '');
              });
              this.ClearAllCellGlyphs();
              return this.DrawEveryCellData();
            }
          }
        } else {
          this.DrawSelectedCellsNormal();
          selectedCells = [whichCell];
          this.DrawSelectedCellsSelected();
          return justSelected = true;
        }
      } else {
        if (!CoordinateIsElement(selectedCells, whichCell)) {
          selectedCells.push(whichCell);
          return this.DrawSelectedCell(whichCell);
        }
      }
    },
    handleMouseUpToolbar0: function() {
      var mouseX, mouseY;
      mouseX = event.clientX;
      mouseY = event.clientY;
      buttonXBoundaries = {
        'open': [5, 56],
        'save': [57, 109]
      };
      return _.forEach(_.keys(buttonXBoundaries), (function(_this) {
        return function(key) {
          var button;
          button = buttonXBoundaries[key];
          if ((mouseX > button[0]) && (button[1] > mouseX)) {
            return _this.buttonFunctions[key].mouseUp(toolbar0, _this.handleSave, _this.handleSaveAs, _this.state.filePath);
          }
        };
      })(this));
    },
    handleClickToolbar1: function(event) {
      var mouseX, mouseY, whichTab;
      mouseX = event.clientX;
      mouseY = event.clientY;
      whichTab = mouseX - 5;
      whichTab = Math.floor(whichTab / 99);
      if (95 > ((mouseX - 5) % 99)) {
        currentSheet = whichTab;
        this.DrawRowNames();
        this.ClearAllCellGlyphs();
        this.DrawEveryCellData();
        return this.drawToolBar1();
      }
    },
    handleSaveAs: function() {
      var csvs, fileExporter;
      csvs = convertToCSVs(Sheets);
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
            fileName = '/' + sheetNames[csvIndex];
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
      csvs = convertToCSVs(Sheets);
      csvs = _.map(csvs, function(csv) {
        return new Buffer(csv, 'utf-8');
      });
      return _.forEach(csvs, (function(_this) {
        return function(csv, csvIndex) {
          var fileName, filePath;
          filePath = _this.state.filePath;
          fileName = '/' + sheetNames[csvIndex];
          fileName += '.csv';
          filePath += fileName;
          return fs.writeFileSync(filePath, csv);
        };
      })(this));
    },
    onKeyUp: function(event) {},
    onKeyDown: function(event) {
      var Next, SC, refreshCellData, thisCell, thisKey;
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
          Next = (function(_this) {
            return function() {};
          })(this);
          refreshCellData = (function(_this) {
            return function(first) {
              first();
              _this.ClearAllCellGlyphs();
              return _this.DrawEveryCellData();
            };
          })(this);
          switch (event.which) {
            case Keys['backspace']:
              if (justSelected) {
                justSelected = false;
              }
              SC = selectedCells[0];
              Sheets[currentSheet][SC[1]][SC[0]] = '';
              break;
            case Keys['enter']:
              justSelected = true;
              Next = (function(_this) {
                return function() {
                  return selectedCells[0][0]++;
                };
              })(this);
              break;
            case Keys['down']:
              if ((selectedCells[0][0] + cellYOrg) < (Sheets[currentSheet][0].length - 1)) {
                justSelected = true;
                Next = (function(_this) {
                  return function() {
                    if ((selectedCells[0][0] % 15) === 14) {
                      cellYOrg++;
                      return refreshCellData(_this.DrawRowNames);
                    } else {
                      return selectedCells[0][0]++;
                    }
                  };
                })(this);
              }
              break;
            case Keys['up']:
              if (0 < (selectedCells[0][0] + cellYOrg)) {
                justSelected = true;
                Next = (function(_this) {
                  return function() {
                    if ((selectedCells[0][0] % 15) === 0) {
                      cellYOrg--;
                      return refreshCellData(_this.DrawRowNames);
                    } else {
                      return selectedCells[0][0]--;
                    }
                  };
                })(this);
              }
              break;
            case Keys['right']:
              if ((selectedCells[0][1] + cellXOrg) < (Sheets[currentSheet].length - 1)) {
                justSelected = true;
                Next = (function(_this) {
                  return function() {
                    if ((selectedCells[0][1] % 8) === 7) {
                      cellXOrg++;
                      return refreshCellData(_this.DrawColumnNames);
                    } else {
                      return selectedCells[0][1]++;
                    }
                  };
                })(this);
              }
              break;
            case Keys['left']:
              if (0 < (selectedCells[0][1] + cellXOrg)) {
                justSelected = true;
                Next = (function(_this) {
                  return function() {
                    if ((selectedCells[0][1] % 8) === 0) {
                      cellXOrg--;
                      return refreshCellData(_this.DrawColumnNames);
                    } else {
                      return selectedCells[0][1]--;
                    }
                  };
                })(this);
              }
              break;
            case Keys['ctrl']:
              doNothing();
              break;
            case Keys['shift']:
              doNothing();
              break;
            case Keys['alt']:
              doNothing();
              break;
            default:
              SC = [selectedCells[0][0] + cellYOrg, selectedCells[0][1] + cellXOrg];
              thisCell = Sheets[currentSheet][SC[1]][SC[0]];
              thisKey = Keys[event.which];
              if (event.shiftKey) {
                if (justSelected) {
                  justSelected = false;
                  thisCell = thisKey.toUpperCase();
                } else {
                  thisCell += thisKey.toUpperCase();
                }
              } else {
                if (justSelected) {
                  justSelected = false;
                  thisCell = thisKey;
                } else {
                  thisCell += thisKey;
                }
              }
              Sheets[currentSheet][SC[1]][SC[0]] = thisCell;
          }
          this.DrawSelectedCellsNormal();
          Next();
          return this.DrawSelectedCellsSelected();
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
        onMouseDown: this.handleClickToolbar0,
        onMouseUp: this.handleMouseUpToolbar0,
        style: {
          backgroundColor: darkerGray,
          width: '100%',
          height: toolbarSize,
          imageRendering: 'pixelated'
        }
      }), canvas({
        id: 'toolbar1',
        onMouseDown: this.handleClickToolbar1,
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
