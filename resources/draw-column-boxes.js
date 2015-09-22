(function() {
  var _, drawABox, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, drawText = ref.drawText;

  drawABox = require('./draw-a-box.js');

  module.exports = function(ctx, color, cell) {
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7], function(columnIndex) {
      var xCor, yCor;
      xCor = (columnIndex * (cell.w - 1)) + (cell.w * 2) - 1;
      yCor = cell.h - 2;
      return drawABox(ctx, color, cell, [xCor, yCor]);
    });
  };

}).call(this);
