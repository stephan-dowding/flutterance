var LiteralFragment;

LiteralFragment = require('../fragments/literalFragment').LiteralFragment;

this.parse = function(input) {
  var c, i, j, len;
  for (i = j = 0, len = input.length; j < len; i = ++j) {
    c = input[i];
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
