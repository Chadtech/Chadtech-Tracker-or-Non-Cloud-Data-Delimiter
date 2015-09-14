(function() {
  module.exports = function(next) {
    var assets, checkForNext, image, load, numberOfAssetsLoaded, totalNumberOfAssets;
    image = function() {
      return document.createElement('IMG');
    };
    assets = {};
    totalNumberOfAssets = 10;
    numberOfAssetsLoaded = 0;
    checkForNext = (function(_this) {
      return function() {
        numberOfAssetsLoaded++;
        if (numberOfAssetsLoaded === totalNumberOfAssets) {
          return next();
        }
      };
    })(this);
    load = (function(_this) {
      return function(key, name) {
        assets[key] = [image(), image()];
        assets[key][0].src = './' + name + '.png';
        assets[key][0].onload = checkForNext;
        assets[key][1].src = './' + name + '-selected.png';
        return assets[key][1].onload = checkForNext;
      };
    })(this);
    load('X', 'x-button');
    load('<+', 'add-column-button');
    load('^+', 'add-row-button');
    load('save', 'save');
    load('open', 'open');
    return assets;
  };

}).call(this);
