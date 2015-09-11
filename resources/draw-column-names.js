(function() {
  var _, drawABox, drawText;

  _ = require('lodash');

  drawText = require('./drawingUtilities.js').drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(sheet, ctx, glyphs, color, cell) {
    return _.forEach(sheet, function(column, columnIndex) {
      var textXOffset, xCor, yCor;
      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2);
      yCor = cell.h;
      textXOffset = Math.floor((cell.w - (11 * ('' + columnIndex).length)) / 2);
      textXOffset -= 2;
      drawABox(ctx, color, cell, [xCor, yCor]);
      return drawText(ctx, glyphs, 1, '' + columnIndex, [xCor + textXOffset, yCor + 4]);
    });
  };

}).call(this);
