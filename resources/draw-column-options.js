(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(currentSheet, ctx, glyphs, color, cell, Assets) {
    var xCor, yCor;
    _.forEach(currentSheet, function(column, columnIndex) {
      var xCor, xOffset, yCor;
      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) + 5;
      yCor = 5;
      xOffset = Math.floor((cell.w - 1) / 2);
      ctx.drawImage(Assets['X'][0], xCor + xOffset + 5, yCor);
      return ctx.drawImage(Assets['<+'][0], xCor + 1, yCor);
    });
    xCor = (currentSheet.length * (cell.w - 1)) + (cell.w * 2) + 5;
    yCor = 5;
    return ctx.drawImage(Assets['<+'][0], xCor + 1, yCor);
  };

}).call(this);
