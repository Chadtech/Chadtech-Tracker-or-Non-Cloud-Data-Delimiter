(function() {
  var drawABorder, fillASquare;

  drawABorder = require('./draw-a-border.js');

  fillASquare = require('./fill-a-square.js');

  module.exports = function(ctx, color, cell, pos) {
    fillASquare(ctx, color, cell, pos);
    return drawABorder(ctx, color, cell, pos);
  };

}).call(this);
