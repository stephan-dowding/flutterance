class @ChooseFragment
  constructor: (@choices) ->

  expand: ->
    [].concat(choice.expand() for choice in @choices ...)
