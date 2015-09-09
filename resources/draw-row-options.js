(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(currentSheet, ctx, glyphs, color, cell, Assets) {
    var xCor, yCor;
    _.forEach(currentSheet[0], function(row, rowIndex) {
      var xCor, yCor;
      xCor = 8;
      yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) + 8;
      ctx.drawImage(Assets['X'][0], xCor + 35, yCor);
      return ctx.drawImage(Assets['^+'][0], xCor, yCor);
    });
    xCor = 8;
    yCor = (currentSheet[0].length * (cell.h - 1)) + (cell.h * 2) + 8;
    return ctx.drawImage(Assets['^+'][0], xCor, yCor);
  };

}).call(this);
