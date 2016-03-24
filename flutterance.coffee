exports.choose = (input, min, max) ->
  choices = []
  choices.push null
  choices.push fragment for fragment in input
  choices
