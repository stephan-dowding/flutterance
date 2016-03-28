treeParser = require('./parsers/treeParser')

@parse = (input) ->
  {fragment: fragment, remainder: remainder} = treeParser.parse(input)
  throw new Error 'malformed expression!' if remainder
  fragment
