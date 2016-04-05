class @ChooseFragment
  constructor: (@choices) ->

  expand: ->
    [].concat(@choices.map((choice) -> choice.expand()) ...)
