(function() {
  var _, drawABox, drawText;

  _ = require('lodash');

  drawText = require('./drawingUtilities.js').drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(sheet, ctx, glyphs, color, cell, cellXOrg) {
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7], function(columnIndex) {
      var columnName, textXOffset, xCor, yCor;
      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) - 1;
      yCor = cell.h - 2;
      columnName = '' + (columnIndex + cellXOrg);
      textXOffset = Math.floor((cell.w - (11 * columnName.length)) / 2);
      textXOffset -= 2;
      return drawText(ctx, glyphs, 1, columnName, [xCor + textXOffset, yCor + 4]);
    });
  };

}).call(this);
