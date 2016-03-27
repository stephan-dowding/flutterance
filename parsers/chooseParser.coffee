{ChooseFragment} = require('../fragments/chooseFragment')
treeParser = require('./treeParser')

exports.parse = (input) ->
  throw new Error('unexpected input') unless input[0] == '['
  {options: options, remainder: remainder} = getOptions input.substring 1
  throw new Error('missing ] after [') unless remainder[0] == ']'

  fragment: new ChooseFragment options
  remainder: remainder.substring 1

getOptions = (input, acc=[]) ->
  {fragment: fragment, remainder: remainder} = treeParser.parse input

  if remainder[0] == '|'
    getOptions remainder.substring(1), acc.concat(fragment)
  else
    options: acc.concat fragment
    remainder: remainder
