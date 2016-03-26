{LiteralFragment} = require '../fragments/literalFragment'

exports.parse = (input) ->
  parseRecur(input, '')

parseRecur = ([head,tail...], acc) ->
  if (!head || head in ['[','|',']'])
    fragment: new LiteralFragment acc
    remainder: if head then (head.concat tail.join('')) else ''
  else
    parseRecur tail, acc.concat head
