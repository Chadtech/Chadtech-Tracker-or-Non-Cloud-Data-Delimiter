(function() {
  var AllCharacters, AssetLoader, Assets, ClearAllCellGlyphs, CoordinateIsElement, DrawColumnBoxes, DrawColumnNames, DrawColumnOptions, DrawEveryCell, DrawEveryCellBorder, DrawEveryCellData, DrawNormalCell, DrawOriginMark, DrawRowBoxes, DrawRowNames, DrawRowOptions, DrawSelectedCell, DrawSheetTabs, Eightx15ify, Glyphs, Index, Keys, LoadGlyphs, React, Sheets, WorkArea, _, borderColor, borderGray, buttonFunctions, buttonXBoundaries, canvas, cell, cellColor, cellXOrg, cellYOrg, convertToCSVs, currentSheet, darkGray, darkerGray, div, doNothing, drawText, edgeColor, gray, gui, hexToArray, injectionPoint, input, justSelected, keyArea, lighterGray, newSheetName, putPixel, ref, ref1, ref2, rowNameRadix, selectedCells, selectedColor, sheetNameJustSelected, sheetNames, toolbarSize, topEdgeColor, zeroPadder;

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
    'save': [56, 108],
    'radix': [264, 287]
  };

  buttonFunctions = {
    open: {
      down: function(ctx) {
        return ctx.drawImage(Assets['open'][1], buttonXBoundaries.open[0], 4);
      },
      up: function(ctx, handleOpen) {
        handleOpen();
        return ctx.drawImage(Assets['open'][0], buttonXBoundaries.open[0], 4);
      }
    },
    save: {
      down: function(ctx) {
        return ctx.drawImage(Assets['save'][1], buttonXBoundaries.save[0], 4);
      },
      up: function(ctx, handleSave, handleSaveAs, saveFilePath) {
        if (saveFilePath !== '') {
          handleSave();
        } else {
          handleSaveAs();
        }
        return ctx.drawImage(Assets['save'][0], buttonXBoundaries.save[0], 4);
      }
    }
  };

  currentSheet = 0;

  sheetNames = [];

  Sheets = [];

  selectedCells = [[2, 3]];

  justSelected = true;

  cellXOrg = 0;

  cellYOrg = 0;

  rowNameRadix = 8;

  newSheetName = 'newSheet';

  sheetNameJustSelected = false;

  keyArea = 'workarea';

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
          var fileExporter, fileImporter, nwDir;
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
          fileExporter.setAttributeNode(nwDir);
          fileImporter = document.getElementById('fileImporter');
          nwDir = window.document.createAttribute('nwdirectory');
          return fileImporter.setAttributeNode(nwDir);
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
      toolbar0.drawImage(Assets['save'][0], 57, 4);
      drawText(toolbar0, Glyphs, 6, 'column radix:', [121, 8]);
      toolbar0.drawImage(Assets['radix-area'][0], 264, 4);
      return drawText(toolbar0, Glyphs, 2, rowNameRadix.toString(36), [270, 9]);
    },
    drawToolBar1: function() {
      var i, point, ref3, sheetXOrg, toolbar1;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1 = toolbar1.getContext('2d');
      toolbar1.fillStyle = '#202020';
      toolbar1.fillRect(0, 0, window.innerWidth, toolbarSize);
      for (point = i = 0, ref3 = window.innerWidth - 1; 0 <= ref3 ? i <= ref3 : i >= ref3; point = 0 <= ref3 ? ++i : --i) {
        borderColor = hexToArray(borderGray);
        putPixel(toolbar1, borderColor, [point, 2]);
        putPixel(toolbar1, borderColor, [point, 3]);
      }
      sheetXOrg = 5;
      _.forEach(Sheets, function(sheet, sheetIndex) {
        var formattedName, glyphXOffset, glyphXOrg, j, k, l, ref4, ref5, ref6, sheetName, tabWidth;
        sheetName = sheetNames[sheetIndex];
        tabWidth = (9 * Glyphs.characterWidth) + 21;
        toolbar1.fillStyle = '#202020';
        toolbar1.fillRect(sheetXOrg + 1, 2, tabWidth - 2, cell.h - 1);
        for (point = j = 0, ref4 = tabWidth; 0 <= ref4 ? j <= ref4 : j >= ref4; point = 0 <= ref4 ? ++j : --j) {
          putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, cell.h + 4]);
          putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, cell.h + 5]);
        }
        for (point = k = 0, ref5 = cell.h + 1; 0 <= ref5 ? k <= ref5 : k >= ref5; point = 0 <= ref5 ? ++k : --k) {
          putPixel(toolbar1, cellColor, [sheetXOrg, point + 3]);
          putPixel(toolbar1, cellColor, [sheetXOrg - 1, point + 4]);
          putPixel(toolbar1, borderColor, [sheetXOrg + tabWidth - 1, point + 3]);
        }
        if (sheetIndex !== currentSheet) {
          for (point = l = 0, ref6 = tabWidth; 0 <= ref6 ? l <= ref6 : l >= ref6; point = 0 <= ref6 ? ++l : --l) {
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, 2]);
            putPixel(toolbar1, borderColor, [sheetXOrg + point - 1, 3]);
          }
        }
        formattedName = sheetName;
        if (formattedName.length > 7) {
          while (formattedName.length > 5) {
            formattedName = formattedName.substring(0, formattedName.length - 1);
          }
          formattedName += '..';
        }
        glyphXOrg = sheetXOrg;
        glyphXOffset = Math.floor((tabWidth - 21) / 2);
        glyphXOffset -= Math.floor((11 * formattedName.length) / 2);
        glyphXOrg += glyphXOffset;
        drawText(toolbar1, Glyphs, 6, formattedName, [glyphXOrg, 9]);
        toolbar1.drawImage(Assets['X'][0], sheetXOrg + tabWidth - 26, 5);
        return sheetXOrg += tabWidth + 4;
      });
      toolbar1.drawImage(Assets['new-sheet-area'][0], window.innerWidth - 28 - 97, 6);
      toolbar1.drawImage(Assets['+'][0], window.innerWidth - 28, 6);
      return drawText(toolbar1, Glyphs, 2, newSheetName, [window.innerWidth - 28 - 97 + 6, 9]);
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
      WorkArea.fillStyle = '#202020';
      WorkArea.fillRect(0, 0, window.innerWidth, window.innerHeight);
      if (Sheets.length) {
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
      }
    },
    handleClickWorkArea: function(event) {
      var mouseX, mouseY, newColumn, refreshCells, refreshSelectedCells, restoreNewColumnButton, restoreXButton, thisColumn, whichCell, xCor, yCor;
      keyArea = 'workarea';
      mouseX = event.clientX;
      mouseY = event.clientY;
      mouseX -= cell.w;
      mouseY -= cell.h;
      mouseY -= toolbarSize + 5;
      whichCell = [(Math.floor((mouseY + 6) / cell.h)) - 1, (Math.floor(mouseX / cell.w)) - 1];
      refreshCells = (function(_this) {
        return function() {
          _this.ClearAllCellGlyphs();
          return _this.DrawEveryCellData();
        };
      })(this);
      refreshSelectedCells = (function(_this) {
        return function(update) {
          _this.DrawSelectedCellsNormal();
          update();
          return _this.DrawSelectedCellsSelected();
        };
      })(this);
      if (!event.metaKey) {
        if ((whichCell[0] < 0) || (whichCell[1] < 0)) {
          if (whichCell[0] === -1) {
            thisColumn = Sheets[currentSheet][whichCell[1]];
            refreshSelectedCells((function(_this) {
              return function() {
                selectedCells = [];
                return _.forEach(thisColumn, function(row, rowIndex) {
                  return selectedCells.push([rowIndex, whichCell[1]]);
                });
              };
            })(this));
          }
          if (whichCell[0] === -2) {
            if ((mouseX % cell.w) < 25) {
              Sheets[currentSheet].splice(whichCell[1] + cellXOrg, 1);
              refreshCells();
              xCor = (whichCell[1] + 2) * (cell.w - 1);
              xCor += 2;
              WorkArea.drawImage(Assets['X'][1], xCor, 0);
              restoreXButton = (function(_this) {
                return function() {
                  return WorkArea.drawImage(Assets['X'][0], xCor, 0);
                };
              })(this);
              setTimeout(restoreXButton, 100);
              if (Sheets[currentSheet].length < 8) {
                newColumn = [];
                _.times(Sheets[currentSheet].length, function() {
                  return newColumn.push('');
                });
                Sheets[currentSheet].push(newColumn);
              }
            } else {
              newColumn = [];
              _.forEach(Sheets[currentSheet][0], function(column) {
                return newColumn.push('');
              });
              Sheets[currentSheet].splice(whichCell[1] + cellXOrg + 1, 0, newColumn);
              refreshCells();
              xCor = (whichCell[1] + 2) * (cell.w - 1);
              xCor += 27;
              WorkArea.drawImage(Assets['<+'][1], xCor, 0);
              restoreNewColumnButton = (function(_this) {
                return function() {
                  return WorkArea.drawImage(Assets['<+'][0], xCor, 0);
                };
              })(this);
              setTimeout(restoreNewColumnButton, 100);
            }
          }
          if (whichCell[1] === -1) {
            refreshSelectedCells((function(_this) {
              return function() {
                selectedCells = [];
                return _.forEach(Sheets[currentSheet], function(column, columnIndex) {
                  return selectedCells.push([whichCell[0], columnIndex]);
                });
              };
            })(this));
          }
          if (whichCell[1] === -2) {
            if (((mouseX + cell.w) % cell.w) < 25) {
              _.forEach(Sheets[currentSheet], function(column) {
                return column.splice(whichCell[0] + cellYOrg, 1);
              });
              refreshCells();
              yCor = (whichCell[0] + 2) * (cell.h - 1);
              WorkArea.drawImage(Assets['X'][1], 1, yCor);
              restoreXButton = (function(_this) {
                return function() {
                  return WorkArea.drawImage(Assets['X'][0], 1, yCor);
                };
              })(this);
              setTimeout(restoreXButton, 100);
              if (Sheets[currentSheet][0].length < 15) {
                newColumn = [];
                return _.forEach(Sheets[currentSheet], function(column, columnIndex) {
                  return Sheets[currentSheet][columnIndex].push('');
                });
              }
            } else {
              _.forEach(Sheets[currentSheet], function(column) {
                return column.splice(whichCell[0] + cellYOrg + 1, 0, '');
              });
              refreshCells();
              yCor = (whichCell[0] + 2) * (cell.h - 1);
              WorkArea.drawImage(Assets['^+'][1], 26, yCor);
              restoreXButton = (function(_this) {
                return function() {
                  return WorkArea.drawImage(Assets['^+'][0], 26, yCor);
                };
              })(this);
              return setTimeout(restoreXButton, 100);
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
    handleClickToolbar0: function(event) {
      var mouseX, mouseY, toolbar0;
      mouseX = event.clientX;
      mouseY = event.clientY;
      toolbar0 = document.getElementById('toolbar0');
      toolbar0 = toolbar0.getContext('2d', {
        alpha: false
      });
      return _.forEach(_.keys(buttonXBoundaries), (function(_this) {
        return function(key) {
          var button;
          button = buttonXBoundaries[key];
          if ((mouseX > button[0]) && (button[1] > mouseX)) {
            return _this.buttonToFunction(toolbar0, key, event.type);
          }
        };
      })(this));
    },
    buttonToFunction: function(ctx, button, direction) {
      switch (direction) {
        case 'mouseup':
          switch (button) {
            case 'save':
              return buttonFunctions.save.up(ctx, this.handleSave, this.handleSaveAs, this.state.filePath);
            case 'open':
              return buttonFunctions.open.up(ctx, this.handleOpen);
            case 'radix':
              return keyArea = 'toolbar0';
          }
          break;
        case 'mousedown':
          switch (button) {
            case 'save':
              return buttonFunctions.save.down(ctx);
            case 'open':
              return buttonFunctions.open.down(ctx);
          }
      }
    },
    handleClickToolbar1: function(event) {
      var leftNewTabButtonEdge, leftSheetNameEdge, mouseX, mouseY, next, rightNewTabButtonEdge, rightSheetNameEdge, tabWidth, toolbar1, whichTab;
      toolbar1 = document.getElementById('toolbar1');
      toolbar1 = toolbar1.getContext('2d');
      mouseX = event.clientX;
      mouseY = event.clientY;
      tabWidth = (9 * Glyphs.characterWidth) + 21;
      whichTab = mouseX - 5;
      whichTab = Math.floor(whichTab / tabWidth);
      if ((tabWidth - 4) > ((mouseX - 5) % tabWidth)) {
        if (!(whichTab > (Sheets.length - 1))) {
          if (((mouseX - 5) % tabWidth) > (tabWidth - 25)) {
            Sheets.splice(whichTab, 1);
            sheetNames.splice(whichTab, 1);
            if (currentSheet > whichTab) {
              currentSheet--;
            }
          } else {
            currentSheet = whichTab;
            cellXOrg = 0;
            cellYOrg = 0;
            this.DrawSelectedCellsNormal();
            selectedCells = [[0, 0]];
          }
          this.DrawRowNames();
          this.ClearAllCellGlyphs();
          this.DrawEveryCellData();
          this.drawToolBar1();
          this.DrawSelectedCellsSelected();
        }
      }
      leftSheetNameEdge = window.innerWidth - 28 - 97;
      rightSheetNameEdge = window.innerWidth - 28;
      if (leftSheetNameEdge < mouseX) {
        if (mouseX < rightSheetNameEdge) {
          keyArea = 'toolbar1';
          newSheetName = '';
          this.drawToolBar1();
        }
      }
      leftNewTabButtonEdge = window.innerWidth - 28;
      rightNewTabButtonEdge = window.innerWidth - 4;
      if (leftNewTabButtonEdge < mouseX) {
        if (mouseX < rightNewTabButtonEdge) {
          toolbar1.drawImage(Assets['+'][1], window.innerWidth - 28, 6);
          next = (function(_this) {
            return function() {
              keyArea = 'workarea';
              Sheets.push(_.clone(require('./new-sheet.js'), true));
              sheetNames.push(newSheetName);
              newSheetName = 'newSheet';
              _this.refreshWorkArea();
              _this.drawToolBar1();
              return toolbar1.drawImage(Assets['+'][0], window.innerWidth - 28, 6);
            };
          })(this);
          return setTimeout(next, 100);
        }
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
          var fileName, filePath;
          _this.setState({
            filePath: event.target.value
          });
          filePath = event.target.value;
          fileName = '/' + sheetNames[currentSheet];
          fileName += '.csv';
          filePath += fileName;
          return fs.writeFileSync(filePath, csvs[currentSheet]);
        };
      })(this));
      return fileExporter.click();
    },
    handleSave: function() {
      var csvs, fileName, filePath;
      csvs = convertToCSVs(Sheets);
      csvs = _.map(csvs, function(csv) {
        return new Buffer(csv, 'utf-8');
      });
      filePath = this.state.filePath;
      fileName = '/' + sheetNames[currentSheet];
      fileName += '.csv';
      filePath += fileName;
      return fs.writeFileSync(filePath, csvs[currentSheet]);
    },
    handleOpen: function() {
      var fileImporter;
      fileImporter = document.getElementById('fileImporter');
      fileImporter.addEventListener('change', (function(_this) {
        return function(event) {
          var csvNames, csvs, directory;
          csvs = [];
          csvNames = [];
          directory = fs.readdirSync(event.target.value);
          _this.setState({
            filePath: event.target.value
          });
          _.forEach(directory, function(f) {
            var ending;
            ending = f.substring(f.length - 4, f.length);
            if (ending === '.csv') {
              csvs.push(event.target.value + '/' + f);
              return csvNames.push(f.substring(0, f.length - 4));
            }
          });
          csvs = _.map(csvs, function(csv) {
            csv = fs.readFileSync(csv, 'utf-8');
            csv = csv.split('\n');
            return csv = _.map(csv, function(column) {
              return column.split(',');
            });
          });
          _.forEach(csvs, function(csv) {
            var results, thisNewColumn;
            _.forEach(csv, function(column) {
              var results;
              results = [];
              while (column.length < 15) {
                console.log('C.4');
                results.push(column.push(''));
              }
              return results;
            });
            results = [];
            while (csv.length < 8) {
              console.log('C.5', csv.length);
              thisNewColumn = [];
              _.times(15, function() {
                return thisNewColumn.push('');
              });
              results.push(csv.push(thisNewColumn));
            }
            return results;
          });
          Sheets = csvs;
          sheetNames = csvNames;
          _this.refreshWorkArea();
          _this.drawToolBar0();
          return _this.drawToolBar1();
        };
      })(this));
      return fileImporter.click();
    },
    onKeyDown: function(event) {
      var Next, SC, refreshCellData, returnToUnclicked, thisCell, thisKey, toolbar0;
      switch (keyArea) {
        case 'workarea':
          if (event.metaKey) {
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
                Sheets[currentSheet][SC[1] + cellXOrg][SC[0] + cellYOrg] = '';
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
                if ((selectedCells[0][0] + cellYOrg) < (Sheets[currentSheet][0].length - 21)) {
                  justSelected = true;
                  Next = (function(_this) {
                    return function() {
                      return _.times(20, function() {
                        if ((selectedCells[0][0] % 15) === 14) {
                          cellYOrg++;
                          return refreshCellData(_this.DrawRowNames);
                        } else {
                          return selectedCells[0][0]++;
                        }
                      });
                    };
                  })(this);
                }
                break;
              case Keys['up']:
                if (0 < (selectedCells[0][0] + cellYOrg)) {
                  justSelected = true;
                  Next = (function(_this) {
                    return function() {
                      return _.times(20, function() {
                        if ((selectedCells[0][0] % 15) === 0) {
                          if (cellYOrg !== 0) {
                            cellYOrg--;
                          }
                          return refreshCellData(_this.DrawRowNames);
                        } else {
                          if (selectedCells[0][0] !== 0) {
                            return selectedCells[0][0]--;
                          }
                        }
                      });
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
                if (thisKey === 'space') {
                  thisKey = ' ';
                }
                if (thisKey.length === 1) {
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
                }
                Sheets[currentSheet][SC[1]][SC[0]] = thisCell;
            }
            this.DrawSelectedCellsNormal();
            Next();
            this.DrawSelectedCellsSelected();
            if (event.which === Keys['s']) {
              if (this.state.filePath) {
                this.handleSave();
              } else {
                this.handleSaveAs();
              }
              toolbar0 = document.getElementById('toolbar0');
              toolbar0 = toolbar0.getContext('2d');
              returnToUnclicked = (function(_this) {
                return function() {
                  return toolbar0.drawImage(Assets['save'][0], buttonXBoundaries.save[0], 4);
                };
              })(this);
              toolbar0.drawImage(Assets['save'][1], buttonXBoundaries.save[0], 4);
              return setTimeout(returnToUnclicked, 300);
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
                  Sheets[currentSheet][SC[1] + cellXOrg][SC[0] + cellYOrg] = '';
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
                  if (thisKey === 'space') {
                    thisKey = ' ';
                  }
                  if (thisKey.length === 1) {
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
                  }
                  Sheets[currentSheet][SC[1]][SC[0]] = thisCell;
              }
              this.DrawSelectedCellsNormal();
              Next();
              return this.DrawSelectedCellsSelected();
            }
          }
          break;
        case 'toolbar0':
          rowNameRadix = parseInt(Keys[event.which].slice(0, 1), 36);
          this.drawToolBar0();
          return this.DrawRowNames();
        case 'toolbar1':
          if (Keys[event.which].length === 1) {
            newSheetName += Keys[event.which];
            return this.drawToolBar1();
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
        onMouseUp: this.handleClickToolbar0,
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
