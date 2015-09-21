(function() {
  var _, drawText, fillASquare, hexToArray, putPixel, ref, zeroPadder;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  zeroPadder = require('./general-utilities.js').zeroPadder;

  fillASquare = require('./fill-a-square.js');

  module.exports = function(ctx, glyphs, color, cell) {
    var corCalc;
    corCalc = function(index, dimension) {
      return (index * (dimension - 1)) + (dimension * 2);
    };
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7], function(columnIndex) {
      return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], function(rowIndex) {
        var xCor, yCor;
        xCor = corCalc(columnIndex, cell.w);
        yCor = corCalc(rowIndex, cell.h);
        return fillASquare(ctx, color, {
          w: cell.w - 4,
          h: cell.h - 4
        }, [xCor + 2, yCor]);
      });
    });
  };

}).call(this);
