{NullFragment} = require '../fragments/nullFragment'
{TreeFragment} = require '../fragments/treeFragment'
literalParser = require './literalParser'
chooseParser = require './chooseParser'

@parse = (input) ->
  if !input || input[0] in ['|', ']']
    return {
      fragment: new NullFragment()
      remainder: input
    }
  {fragment: left, remainder: remainder} = if input[0] == '[' then chooseParser.parse input else literalParser.parse input
  {fragment: right, remainder: remainder} = @parse remainder

  fragment: new TreeFragment(left, right)
  remainder: remainder
