(function() {
  var _;

  _ = require('lodash');

  module.exports = function(sheets) {
    var delimit, delimitItem, delimitRow;
    delimit = function(a, b, delimiter) {
      return a + delimiter + b;
    };
    delimitItem = function(a, b) {
      return delimit(a, b, ',');
    };
    delimitRow = function(a, b) {
      return delimit(a, _.reduce(b, delimitItem), '\n');
    };
    return _.map(sheets, function(sheet) {
      return _.reduce(sheet, delimitRow);
    });
  };

}).call(this);
