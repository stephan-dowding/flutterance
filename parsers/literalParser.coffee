{LiteralFragment} = require '../fragments/literalFragment'

exports.parse = (input) ->
  index = nextSpecialCharIndex(input)
  if index
    fragment: new LiteralFragment input.substring(0, index)
    remainder: input.substring(index)
  else
    fragment: new LiteralFragment input
    remainder: ''

nextSpecialCharIndex = (string) ->
  indices = ['[', '|', ']'].map((char) -> string.indexOf(char)).filter((index) -> index > -1)
  Math.min(indices...)
