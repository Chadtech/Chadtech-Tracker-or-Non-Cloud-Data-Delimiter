_ = require 'lodash'

module.exports = (array, el0) ->
  equalities = _.map array, (el1, elementIndex) ->
    (el0[ 0 ] is el1[ 0 ]) and (el0[ 1 ] is el1[ 1 ])
  _.reduce equalities, (sum, truthValue) ->
    sum or truthValue

