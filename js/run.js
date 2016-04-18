#!/usr/bin/env node
;
var flutterance;

flutterance = require('./flutterance');

if (!(process.argv[2] && process.argv[3])) {
  console.error("Correct usage is:\n  flutterance <input-file> <output-file>");
  process.exit(1);
}

flutterance.readFromFile(process.argv[2]).then(function(lines) {
  var fragments, sentences;
  fragments = flutterance.parseLines(lines);
  sentences = flutterance.expandAll(fragments);
  return flutterance.writeToFile(sentences, process.argv[3]);
})["catch"](function(error) {
  console.error(error);
  return process.exit(1);
});
