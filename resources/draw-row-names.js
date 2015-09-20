(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(sheet, ctx, glyphs, color, cell, cellYOrg) {
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], function(rowIndex) {
      var rowName, textXOffset, xCor, yCor;
      xCor = cell.w;
      yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 3;
      textXOffset = Math.floor((cell.w - (11 * ('' + rowIndex).length)) / 2);
      textXOffset -= 2;
      rowName = '' + (rowIndex + cellYOrg);
      drawABox(ctx, color, cell, [xCor, yCor]);
      return drawText(ctx, glyphs, 1, rowName, [xCor + textXOffset, yCor + 4]);
    });
  };

}).call(this);
