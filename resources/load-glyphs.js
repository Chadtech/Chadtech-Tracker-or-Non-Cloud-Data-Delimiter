(function() {
  var _;

  _ = require('lodash');

  module.exports = function(allCharacters) {
    var characters, image;
    image = function() {
      return document.createElement('IMG');
    };
    characters = {
      images: {
        0: {},
        1: {},
        2: {},
        3: {},
        4: {}
      }
    };
    _.forEach([0, 1, 2, 3, 4], function(CS) {
      return _.forEach(allCharacters, function(character, characterIndex) {
        var fileName, fontName;
        characters.images[CS][character] = image();
        fileName = '' + characterIndex;
        while (fileName.length < 3) {
          fileName = '0' + fileName;
        }
        fontName = './hfnssC' + CS + '/hfnssC' + CS + '_';
        fileName = fontName + fileName + '.png';
        return characters.images[CS][character].src = fileName;
      });
    });
    return characters;
  };

}).call(this);
