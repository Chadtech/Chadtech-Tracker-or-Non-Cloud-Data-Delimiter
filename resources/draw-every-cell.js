(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(currentSheet, ctx, glyphs, color, cell) {
    return _.forEach(currentSheet, function(column, columnIndex) {
      return _.forEach(column, function(datum, datumIndex) {
        var xCor, yCor;
        xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 7;
        yCor = (datumIndex * (cell.h - 1)) + (cell.h * 2) + 7;
        drawText(ctx, glyphs, 1, datum, [xCor + 4, yCor + 4]);
        return drawABox(ctx, color, cell, [xCor, yCor]);
      });
    });
  };

}).call(this);
