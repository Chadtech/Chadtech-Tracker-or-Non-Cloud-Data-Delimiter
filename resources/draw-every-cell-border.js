(function() {
  var _, drawABorder, drawText, hexToArray, putPixel, ref, zeroPadder;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  zeroPadder = require('./general-utilities.js').zeroPadder;

  drawABorder = require('./draw-a-border.js');

  module.exports = function(sheet, ctx, glyphs, color, cell) {
    var corCalc;
    corCalc = function(index, dimension) {
      return (index * (dimension - 1)) + (dimension * 2) - 1;
    };
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8], function(columnIndex) {
      return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], function(rowIndex) {
        var xCor, yCor;
        xCor = corCalc(columnIndex, cell.w);
        yCor = (corCalc(rowIndex, cell.h)) - 2;
        return drawABorder(ctx, color, cell, [xCor, yCor]);
      });
    });
  };

}).call(this);
