(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref, zeroPadder;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  zeroPadder = require('./general-utilities.js').zeroPadder;

  module.exports = function(sheet, ctx, glyphs, color, cell) {
    var corCalc;
    corCalc = function(index, dimension) {
      return (index * (dimension - 1)) + (dimension * 2) - 1;
    };
    return _.forEach(sheet, function(column, columnIndex) {
      return _.forEach(column, function(datum, rowIndex) {
        var xCor, yCor;
        xCor = corCalc(columnIndex, cell.w);
        yCor = corCalc(rowIndex, cell.h);
        if (datum.length) {
          return drawText(ctx, glyphs, 1, datum, [xCor + 4, yCor + 3]);
        }
      });
    });
  };

}).call(this);
