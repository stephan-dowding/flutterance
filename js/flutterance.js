var treeParser = require('./parsers/treeParser');
var LineByLineReader = require('line-by-line');
var fs = require('fs');
var os = require('os');

this.parse = function(input) {
  var fragment, ref, remainder;
  ref = treeParser.parse(input), fragment = ref.fragment, remainder = ref.remainder;
  if (remainder) {
    throw new Error('unexpected | or ]');
  }
  return fragment;
};

this.readFromFile = function(file) {
  return new Promise(function(resolve, reject) {
    var lines, number, rl;
    rl = new LineByLineReader(file);
    lines = [];
    number = 0;
    rl.on('line', function(line) {
      ++number;
      if (line) {
        return lines.push({
          number: number,
          text: line
        });
      }
    });
    rl.on('end', function() {
      return resolve(lines);
    });
    return rl.on('error', function(err) {
      return reject(err);
    });
  });
};

this.parseLines = function(lines) {
  return lines.map((function(_this) {
    return function(line) {
      var error, error1;
      try {
        return _this.parse(line.text);
      } catch (error1) {
        error = error1;
        throw new Error("Line " + line.number + ": " + line.text + "\n  " + error);
      }
    };
  })(this));
};

this.expandAll = function(fragments) {
  var fragment, ref;
  return Array.from(new Set((ref = []).concat.apply(ref, (function() {
    var i, len, results;
    results = [];
    for (i = 0, len = fragments.length; i < len; i++) {
      fragment = fragments[i];
      results.push(fragment.expand());
    }
    return results;
  })()).map(normalise)));
};

this.writeToFile = function(sentences, file) {
  return fs.writeFileSync(file, sentences.join(os.EOL));
};

var normalise = function(s) {
  return s.trim().replace(/\s+/g, ' ');
};
