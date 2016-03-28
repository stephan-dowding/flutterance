{LiteralFragment} = require '../fragments/literalFragment'

@parse = (input) ->
  return {
    fragment: new LiteralFragment input.substring(0, i)
    remainder: input.substring i
  } for c, i in input when c in ['[','|',']']
  fragment: new LiteralFragment input
