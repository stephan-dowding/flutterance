#!/usr/bin/env node
;
const flutterance = require('./flutterance');

flutterance.processPhrases = function(input_file, output_file){
    if (!(input_file && output_file)) {
        console.error("Flutterance requires an input and output file");
        process.exit(1);
    }

    flutterance.readFromFile(input_file).then(function(lines) {
        var fragments, sentences;
        fragments = flutterance.parseLines(lines);
        sentences = flutterance.expandAll(fragments);
        return flutterance.writeToFile(sentences, output_file);
    })["catch"](function(error) {
        console.error(error);
        return process.exit(1);
    });
}

module.exports = flutterance;






