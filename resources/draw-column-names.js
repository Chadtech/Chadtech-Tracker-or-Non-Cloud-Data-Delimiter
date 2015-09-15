(function() {
  var _, drawABox, drawText;

  _ = require('lodash');

  drawText = require('./drawingUtilities.js').drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(sheet, ctx, glyphs, color, cell, cellXOrg) {
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8], function(columnIndex) {
      var columnName, textXOffset, xCor, yCor;
      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) - 1;
      yCor = cell.h;
      textXOffset = Math.floor((cell.w - (11 * ('' + columnIndex).length)) / 2);
      textXOffset -= 2;
      columnName = '' + (columnIndex + cellXOrg);
      drawABox(ctx, color, cell, [xCor, yCor]);
      return drawText(ctx, glyphs, 1, columnName, [xCor + textXOffset, yCor + 4]);
    });
  };

}).call(this);
