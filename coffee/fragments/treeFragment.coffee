class @TreeFragment
  constructor: (@left, @right) ->

  expand: ->
    leftItems = @left.expand()
    rightItems = @right.expand()
    [].concat(leftItems.map((leftItem) -> rightItems.map((rightItem) -> leftItem + rightItem)) ...)
