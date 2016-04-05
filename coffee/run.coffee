`#!/usr/bin/env node`
flutterance = require('./flutterance')

flutterance.readFromFile(process.argv[2])
.then (lines) ->
  fragments = flutterance.parseLines(lines)
  sentences = flutterance.expandAll(fragments)
  flutterance.writeToFile sentences, process.argv[3]
.catch (error) ->
  console.error error
