(function() {
  var _;

  _ = require('lodash');

  module.exports = function(array, el0) {
    var equalities;
    equalities = _.map(array, function(el1, elementIndex) {
      return (el0[0] === el1[0]) && (el0[1] === el1[1]);
    });
    return _.reduce(equalities, function(sum, truthValue) {
      return sum || truthValue;
    });
  };

}).call(this);
