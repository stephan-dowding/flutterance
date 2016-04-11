{ChooseFragment} = require('../fragments/chooseFragment')
treeParser = require('./treeParser')

@parse = (input) ->
  throw new Error('unexpected input') unless input[0] == '['
  {options: options, remainder: remainder} = getOptions input.substring 1
  throw new Error('missing ] after [') unless remainder && remainder[0] == ']'

  {min: min, max: max, remainder: remainder} = getMode options.length, remainder.substring 1

  fragment: new ChooseFragment options, min, max
  remainder: remainder

getOptions = (input, acc=[]) ->
  {fragment: fragment, remainder: remainder} = treeParser.parse input

  if remainder && remainder[0] == '|'
    getOptions remainder.substring(1), acc.concat(fragment)
  else
    options: acc.concat fragment
    remainder: remainder

getMode = (maxLength, remainder) ->
  if remainder[0] == '?'
    return {
      min: 0
      max: 1
      remainder: remainder.substring 1
    }
  if remainder[0] == '+'
    return {
      min: 1
      max: maxLength
      remainder: remainder.substring 1
    }
  if remainder[0] == '*'
    return {
      min: 0
      max: maxLength
      remainder: remainder.substring 1
    }
  {
    min: 1
    max: 1
    remainder: remainder
  }
