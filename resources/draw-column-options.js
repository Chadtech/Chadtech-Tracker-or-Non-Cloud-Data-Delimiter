(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(currentSheet, ctx, glyphs, color, cell, Assets) {
    var xCalc, xCor, yCor;
    xCalc = (function(_this) {
      return function(index) {
        return index * (cell.w - 1) + (cell.w * 2);
      };
    })(this);
    yCor = 0;
    _.forEach(currentSheet, function(column, columnIndex) {
      var xCor;
      xCor = xCalc(columnIndex);
      ctx.drawImage(Assets['X'][0], xCor + 35, yCor);
      return ctx.drawImage(Assets['<+'][0], xCor, yCor);
    });
    xCor = xCalc(currentSheet.length);
    return ctx.drawImage(Assets['<+'][0], xCor, yCor);
  };

}).call(this);
