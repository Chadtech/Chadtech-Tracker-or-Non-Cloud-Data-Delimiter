(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText, drawABox = ref.drawABox;

  drawABox = require('./draw-a-box.js');

  module.exports = function(currentSheet, ctx, glyphs, color, cell, pos) {
    var datum, xCor, yCor;
    xCor = (pos[1] * (cell.w - 1)) + (cell.w * 2) + 7;
    yCor = (pos[0] * (cell.h - 1)) + (cell.h * 2) + 7;
    datum = currentSheet[pos[1]][pos[0]];
    drawText(ctx, glyphs, 0, datum, [xCor + 4, yCor + 5]);
    return drawABox(ctx, color, cell, [xCor, yCor]);
  };

}).call(this);
