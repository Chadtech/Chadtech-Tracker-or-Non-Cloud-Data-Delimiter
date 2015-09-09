(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(currentSheet, ctx, glyphs, color, cell, Assets) {
    var xCor, yCor;
    _.forEach(currentSheet, function(column, columnIndex) {
      var xCor, yCor;
      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 8;
      yCor = 8;
      ctx.drawImage(Assets['X'][0], xCor + 35, yCor);
      return ctx.drawImage(Assets['<+'][0], xCor, yCor);
    });
    xCor = (currentSheet.length * (cell.w - 1)) + (cell.w * 2) + 8;
    yCor = 8;
    return ctx.drawImage(Assets['<+'][0], xCor, yCor);
  };

}).call(this);
