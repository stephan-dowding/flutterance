class @ChooseFragment
  constructor: (@choices, @min = 1) ->

  expand: ->
    [].concat([@min..1].map((n) => @expandX(n)) ...)

  expandX: (n) ->
    return [''] if n == 0
    [].concat(@choices.map((choice) -> choice.expand()) ...)
