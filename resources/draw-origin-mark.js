(function() {
  var _, arrayToHex, drawText, fillASquare, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  fillASquare = require('./fill-a-square.js');

  module.exports = function(sheetName, ctx, glyphs, color, cell, Assets) {
    var bigBox, xCor, yCor;
    xCor = 0;
    yCor = 0;
    bigBox = {
      h: (cell.h * 2) - 2,
      w: (cell.w * 2) - 1
    };
    ctx.fillStyle = '#202020';
    ctx.fillRect(xCor, yCor, bigBox.w, bigBox.h);
    ctx.drawImage(Assets['^+'][0], 26, yCor + cell.h - 1);
    ctx.drawImage(Assets['<+'][0], xCor + 26 + cell.w, 0);
    ctx.fillStyle = '#000000';
    return ctx.fillRect(cell.w + 2, cell.h, (cell.w * 2) - 2, cell.h * 2);
  };

}).call(this);
