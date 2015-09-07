(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(currentSheet, ctx, glyphs, color, cell) {
    return _.forEach(currentSheet[0], function(row, rowIndex) {
      var textXOffset, xCor, yCor;
      xCor = cell.w + 5;
      yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) + 5;
      textXOffset = Math.floor((cell.w - (11 * ('' + rowIndex).length)) / 2);
      textXOffset -= 2;
      drawText(ctx, glyphs, 1, '' + rowIndex, [xCor + textXOffset, yCor + 3]);
      return drawABox(ctx, color, cell, [xCor, yCor]);
    });
  };

}).call(this);
