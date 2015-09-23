(function() {
  module.exports = function(next) {
    var assets, checkForNext, image, load, numberOfAssetsLoaded, totalNumberOfAssets;
    image = function() {
      return document.createElement('IMG');
    };
    assets = {};
    totalNumberOfAssets = 14;
    numberOfAssetsLoaded = 0;
    checkForNext = (function(_this) {
      return function(a, b, c, d) {
        numberOfAssetsLoaded++;
        if (numberOfAssetsLoaded === totalNumberOfAssets) {
          return next();
        }
      };
    })(this);
    load = (function(_this) {
      return function(key, name, selectedImage) {
        assets[key] = [image(), image()];
        assets[key][0].src = './' + name + '.png';
        assets[key][0].onload = checkForNext;
        if (selectedImage) {
          assets[key][1].src = './' + name + '-selected.png';
          return assets[key][1].onload = checkForNext;
        }
      };
    })(this);
    load('X', 'x-button', true);
    load('<+', 'add-column-button', true);
    load('^+', 'add-row-button', true);
    load('save', 'save', true);
    load('open', 'open', true);
    load('+', 'add-sheet', true);
    load('radix-area', 'radix-area', false);
    load('new-sheet-area', 'new-sheet-area', false);
    return assets;
  };

}).call(this);
