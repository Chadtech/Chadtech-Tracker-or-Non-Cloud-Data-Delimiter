(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(ctx, color, cell) {
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], function(rowIndex) {
      var xCor, yCor;
      xCor = cell.w;
      yCor = (rowIndex * (cell.h - 1)) + (cell.h * 2) - 3;
      return drawABox(ctx, color, cell, [xCor, yCor]);
    });
  };

}).call(this);
