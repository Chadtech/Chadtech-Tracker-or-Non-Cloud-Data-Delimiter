(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(sheet, ctx, glyphs, color, cell, Assets) {
    var xCalc, yCor;
    xCalc = (function(_this) {
      return function(index) {
        return index * (cell.w - 1) + (cell.w * 2);
      };
    })(this);
    yCor = 0;
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8], function(columnIndex) {
      var xCor;
      xCor = xCalc(columnIndex);
      ctx.drawImage(Assets['X'][0], xCor, yCor);
      return ctx.drawImage(Assets['<+'][0], xCor + 25, yCor);
    });
  };

}).call(this);
