class @TreeFragment
  constructor: (@left, @right) ->

  expand: ->
    leftItems = @left.expand()
    rightItems = @right.expand()
    [].concat(leftItem + rightItem for rightItem in rightItems for leftItem in leftItems ...)
