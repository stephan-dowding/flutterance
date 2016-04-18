var ChooseFragment = require('../fragments/chooseFragment').ChooseFragment;
var treeParser = require('./treeParser');

this.parse = function(input) {
  var max, min, mode, options, ref, ref1, remainder;
  if (input[0] !== '[') {
    throw new Error('unexpected input');
  }
  ref = getOptions(input.substring(1)), options = ref.options, remainder = ref.remainder;
  if (!(remainder && remainder[0] === ']')) {
    throw new Error('missing ] after [');
  }
  ref1 = getMode(options.length, remainder.substring(1)), min = ref1.min, max = ref1.max, mode = ref1.mode, remainder = ref1.remainder;
  return {
    fragment: new ChooseFragment(options, min, max, mode),
    remainder: remainder
  };
};

function getOptions(input, acc) {
  var fragment, ref, remainder;
  if (acc == null) {
    acc = [];
  }
  ref = treeParser.parse(input), fragment = ref.fragment, remainder = ref.remainder;
  if (remainder && remainder[0] === '|') {
    return getOptions(remainder.substring(1), acc.concat(fragment));
  } else {
    return {
      options: acc.concat(fragment),
      remainder: remainder
    };
  }
};

function getMode(maxLength, remainder) {
  return getModeR(maxLength, remainder, {
    min: 1,
    max: 1,
    mode: 'ordered'
  });
};

function getModeR(maxLength, remainder, meta) {
  var fullmatch, match, max, min;
  if (remainder[0] === '?') {
    meta.min = 0;
    meta.max = 1;
    return getModeR(maxLength, remainder.substring(1), meta);
  }
  if (remainder[0] === '+') {
    meta.min = 1;
    meta.max = maxLength;
    return getModeR(maxLength, remainder.substring(1), meta);
  }
  if (remainder[0] === '*') {
    meta.min = 0;
    meta.max = maxLength;
    return getModeR(maxLength, remainder.substring(1), meta);
  }
  if (remainder[0] === '~') {
    meta.mode = 'unordered';
    return getModeR(maxLength, remainder.substring(1), meta);
  }
  if (remainder[0] === '>') {
    meta.mode = 'left';
    return getModeR(maxLength, remainder.substring(1), meta);
  }
  if (remainder[0] === '<') {
    meta.mode = 'right';
    return getModeR(maxLength, remainder.substring(1), meta);
  }
  if (remainder[0] === '(') {
    match = remainder.match(/^\((\d+|\*)(?:,\s*(\d+|\*))?\)/);
    if (!match) {
      throw new Error('invalid format after \'(\'...\nit should be (n) or (n,m) where n and m are an integer or *');
    }
    fullmatch = match[0], min = match[1], max = match[2];
    if (!max) {
      max = min;
    }
    meta.min = parseNumber(min, maxLength);
    meta.max = parseNumber(max, maxLength);
    return getModeR(maxLength, remainder.substring(fullmatch.length), meta);
  }
  meta.remainder = remainder;
  return meta;
};

function parseNumber(input, wild) {
  return input === '*' ? wild : parseInt(input);
};
