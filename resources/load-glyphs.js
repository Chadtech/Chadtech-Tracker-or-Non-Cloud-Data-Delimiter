(function() {
  var _;

  _ = require('lodash');

  module.exports = function(allCharacters) {
    var characters;
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
        var fileName;
        characters.images[CS][character] = document.createElement('IMG');
        fileName = '' + characterIndex;
        while (fileName.length < 3) {
          fileName = '0' + fileName;
        }
        fileName = './hfnssC' + CS + '/hfnssC' + CS + '_' + fileName + '.png';
        return characters.images[CS][character].src = fileName;
      });
    });
    return characters;
  };

}).call(this);
