(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(currentSheet, ctx, glyphs, color, cell) {
    var corCalc;
    corCalc = function(index, dimension) {
      return (index * (dimension - 1)) + (dimension * 2);
    };
    return _.forEach(currentSheet, function(column, columnIndex) {
      return _.forEach(column, function(datum, datumIndex) {
        var xCor, yCor;
        xCor = corCalc(columnIndex, cell.w);
        yCor = corCalc(datumIndex, cell.h);
        drawABox(ctx, color, cell, [xCor, yCor]);
        return drawText(ctx, glyphs, 1, datum, [xCor + 4, yCor + 5]);
      });
    });
  };

}).call(this);
