class @ChooseFragment
  constructor: (@choices, @min, @max, @mode) ->

  expand: ->
    flatten([@min..@max].map((n) => @expandX(n, @choices)))

  expandX: (n, choices) ->
    return [] if n > choices.length
    return [''] if n == 0
    return choices.map((choice) -> choice.expand()) if n == 1
    return @expandX(n, choices[1..]).concat(@expandX(n-1, choices[1..]).map((end) -> choices[0].expand().map((start) -> "#{start}#{end}"))) unless @mode == 'unordered'
    flatten(choices.map((startElem, i) => @expandX(n-1, rem(choices, i)).map((end) -> startElem.expand().map((start) -> "#{start}#{end}"))))

  rem = (arr, i) ->
    temp = arr.slice(0)
    temp.splice(i, 1)
    temp

  flatten = (arr) ->
    arr.reduce (flat, toFlatten) ->
      items = if Array.isArray(toFlatten)
        flatten(toFlatten)
      else
        toFlatten
      flat.concat(items)
    , []
