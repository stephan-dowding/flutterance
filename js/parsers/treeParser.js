var NullFragment, TreeFragment, chooseParser, literalParser;

NullFragment = require('../fragments/nullFragment').NullFragment;

TreeFragment = require('../fragments/treeFragment').TreeFragment;

literalParser = require('./literalParser');

chooseParser = require('./chooseParser');

this.parse = function(input) {
  var left, ref, ref1, ref2, remainder, right;
  if (!input || ((ref = input[0]) === '|' || ref === ']')) {
    return {
      fragment: new NullFragment(),
      remainder: input
    };
  }
  ref1 = input[0] === '[' ? chooseParser.parse(input) : literalParser.parse(input), left = ref1.fragment, remainder = ref1.remainder;
  ref2 = this.parse(remainder), right = ref2.fragment, remainder = ref2.remainder;
  return {
    fragment: new TreeFragment(left, right),
    remainder: remainder
  };
};
