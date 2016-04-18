var LiteralFragment;

LiteralFragment = require('../fragments/literalFragment').LiteralFragment;

this.parse = function(input) {
  for (var i = 0; i < input.length; ++i) {
    var c = input[i];
    if (c === '[' || c === '|' || c === ']') {
      return {
        fragment: new LiteralFragment(input.substring(0, i)),
        remainder: input.substring(i)
      };
    }
  }
  return {
    fragment: new LiteralFragment(input)
  };
};
