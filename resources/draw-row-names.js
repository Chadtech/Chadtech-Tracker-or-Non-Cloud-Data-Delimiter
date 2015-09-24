(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(sheet, ctx, glyphs, color, cell, cellYOrg, radix) {
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], function(rowIndex) {
      var rowName, textXOffset, xCor, yCor;
      xCor = cell.w;
      yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 3;
      rowName = (rowIndex + cellYOrg).toString(radix);
      textXOffset = Math.floor((cell.w - (11 * rowName.length)) / 2);
      textXOffset -= 2;
      ctx.fillStyle = '#000000';
      ctx.fillRect(xCor + 2, yCor + 2, cell.w - 3, cell.h - 3);
      return drawText(ctx, glyphs, 1, rowName, [xCor + textXOffset, yCor + 4]);
    });
  };

}).call(this);
