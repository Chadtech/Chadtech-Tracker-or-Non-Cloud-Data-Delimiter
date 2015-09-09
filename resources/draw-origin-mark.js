(function() {
  var _, arrayToHex, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(currentSheet, ctx, glyphs, color, cell, sheetName) {
    var bigBox, xCor, xOffSet, yCor;
    xCor = 8;
    yCor = 8;
    bigBox = {
      h: cell.h * 2,
      w: cell.w * 2
    };
    xOffSet = Math.floor((cell.w * 2 - (11 * sheetName.length)) / 2);
    drawABox(ctx, color, bigBox, [xCor, yCor]);
    return drawText(ctx, glyphs, 1, sheetName, [xCor + 4 + xOffSet, yCor + 16]);
  };

}).call(this);
