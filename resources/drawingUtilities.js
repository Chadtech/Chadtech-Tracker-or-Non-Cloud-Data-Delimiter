(function() {
  var _;

  _ = require('lodash');

  module.exports = {
    putPixel: function(ctx, color, pos) {
      var newPixel, newPixelsColor;
      newPixel = ctx.createImageData(1, 1);
      newPixelsColor = newPixel.data;
      newPixelsColor[0] = color[0];
      newPixelsColor[1] = color[1];
      newPixelsColor[2] = color[2];
      newPixelsColor[3] = 255;
      return ctx.putImageData(newPixel, pos[0], pos[1]);
    },
    hexToArray: function(color) {
      var colorArray;
      colorArray = [];
      colorArray.push(color.slice(1, 3));
      colorArray.push(color.slice(3, 5));
      colorArray.push(color.slice(5, 7));
      colorArray = _.map(colorArray, function(colorValue) {
        return parseInt(colorValue, 16);
      });
      colorArray.push(255);
      return colorArray;
    },
    arrayToHex: function(color) {
      var colorHex;
      colorHex = '#';
      colorHex += color[0].toString(16);
      colorHex += color[1].toString(16);
      colorHex += color[2].toString(16);
      return colorHex;
    },
    drawText: function(ctx, glyphs, CS, text, pos) {
      return _.forEach(text, function(character, characterIndex) {
        var xCor, yCor;
        xCor = pos[0];
        yCor = pos[1];
        xCor += characterIndex * glyphs.characterWidth;
        return ctx.drawImage(glyphs.images[CS][character], xCor, yCor);
      });
    }
  };

}).call(this);
