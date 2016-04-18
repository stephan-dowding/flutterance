var NullFragment = require('../fragments/nullFragment').NullFragment;
var TreeFragment = require('../fragments/treeFragment').TreeFragment;
var literalParser = require('./literalParser');
var chooseParser = require('./chooseParser');

this.parse = function(input) {
  if (!input || input[0] === '|' || input[0] === ']') {
    return {
      fragment: new NullFragment(),
      remainder: input
    };
  }
  var output = (input[0] === '[') ? chooseParser.parse(input) : literalParser.parse(input);
  var left = output.fragment
  var output = this.parse(output.remainder)
  var right = output.fragment
  return {
    fragment: new TreeFragment(left, right),
    remainder: output.remainder
  };
};
