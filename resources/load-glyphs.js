(function() {
  var _;

  _ = require('lodash');

  module.exports = function(allCharacters, next) {
    var characters, image, numberOfLoadedGlyphs, totalNumberOfGlyphs;
    image = function() {
      return document.createElement('IMG');
    };
    characters = {
      images: {
        0: {},
        1: {},
        2: {},
        4: {},
        6: {}
      }
    };
    totalNumberOfGlyphs = 5 * allCharacters.length;
    numberOfLoadedGlyphs = 0;
    _.forEach([0, 1, 2, 4, 6], function(CS) {
      return _.forEach(allCharacters, function(character, characterIndex) {
        var fileName, fontName;
        characters.images[CS][character] = image();
        fileName = '' + characterIndex;
        while (fileName.length < 3) {
          fileName = '0' + fileName;
        }
        fontName = './hfnssC' + CS + '/hfnssC' + CS + '_';
        fileName = fontName + fileName + '.png';
        characters.images[CS][character].src = fileName;
        return characters.images[CS][character].onload = (function(_this) {
          return function() {
            numberOfLoadedGlyphs++;
            if (numberOfLoadedGlyphs === totalNumberOfGlyphs) {
              return next();
            }
          };
        })(this);
      });
    });
    return characters;
  };

}).call(this);
