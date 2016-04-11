class @ChooseFragment
  constructor: (@choices, @min, @max) ->

  expand: ->
    [].concat([@min..@max].map((n) => @expandX(n, @choices)) ...)

  expandX: (n, choices) ->
    return [] if n > choices.length
    return [''] if n == 0
    return [].concat(choices.map((choice) -> choice.expand()) ...) if n == 1
    @expandX(n, choices[1..]).concat(@expandX(n-1, choices[1..]).map((end) -> choices[0].expand().map((start) -> "#{start}#{end}")) ...)
