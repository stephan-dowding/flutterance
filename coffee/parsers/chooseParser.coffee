{ChooseFragment} = require('../fragments/chooseFragment')
treeParser = require('./treeParser')

@parse = (input) ->
  throw new Error('unexpected input') unless input[0] == '['
  {options: options, remainder: remainder} = getOptions input.substring 1
  throw new Error('missing ] after [') unless remainder && remainder[0] == ']'

  {min: min, max: max, mode: mode, remainder: remainder} = getMode options.length, remainder.substring 1

  fragment: new ChooseFragment options, min, max, mode
  remainder: remainder

getOptions = (input, acc=[]) ->
  {fragment: fragment, remainder: remainder} = treeParser.parse input

  if remainder && remainder[0] == '|'
    getOptions remainder.substring(1), acc.concat(fragment)
  else
    options: acc.concat fragment
    remainder: remainder

getMode = (maxLength, remainder) ->
  getModeR(maxLength, remainder, {min: 1, max: 1, mode: 'ordered'})

getModeR = (maxLength, remainder, meta) ->
  if remainder[0] == '?'
    meta.min = 0
    meta.max = 1
    return getModeR maxLength, remainder.substring(1), meta
  if remainder[0] == '+'
    meta.min = 1
    meta.max = maxLength
    return getModeR maxLength, remainder.substring(1), meta
  if remainder[0] == '*'
    meta.min = 0
    meta.max = maxLength
    return getModeR maxLength, remainder.substring(1), meta
  if remainder[0] == '~'
    meta.mode = 'unordered'
    return getModeR maxLength, remainder.substring(1), meta
  if remainder[0] == '>'
    meta.mode = 'left'
    return getModeR maxLength, remainder.substring(1), meta
  if remainder[0] == '<'
    meta.mode = 'right'
    return getModeR maxLength, remainder.substring(1), meta
  if remainder[0] == '('
    match = remainder.match /^\((\d+)\)/
    throw new Error('invalid format after \'(\'... it should be (n) where n is an integer') unless match
    [fullmatch, number, ...] = remainder.match /^\((\d+)\)/
    num = parseInt(number)
    meta.min = num
    meta.max = num
    return getModeR maxLength, remainder.substring(fullmatch.length), meta
  meta.remainder = remainder
  meta
