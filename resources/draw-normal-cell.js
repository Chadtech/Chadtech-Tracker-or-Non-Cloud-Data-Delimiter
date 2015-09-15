(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText, drawABox = ref.drawABox;

  drawABox = require('./draw-a-box.js');

  module.exports = function(sheet, ctx, glyphs, color, cell, pos) {
    var corCalc, datum, xCor, yCor;
    corCalc = function(index, dimension) {
      return (index * (dimension - 1)) + (dimension * 2) - 1;
    };
    xCor = corCalc(pos[1], cell.w);
    yCor = corCalc(pos[0], cell.h);
    datum = sheet[pos[1]][pos[0]];
    drawABox(ctx, color, cell, [xCor, yCor]);
    return drawText(ctx, glyphs, 1, datum, [xCor + 4, yCor + 5]);
  };

}).call(this);
