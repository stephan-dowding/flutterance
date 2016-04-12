`#!/usr/bin/env node`
flutterance = require('./flutterance')

unless process.argv[2] && process.argv[3]
  console.error ("""
  Correct usage is:
    flutterance <input-file> <output-file>
  """)
  process.exit(1)

flutterance.readFromFile(process.argv[2])
.then (lines) ->
  fragments = flutterance.parseLines(lines)
  sentences = flutterance.expandAll(fragments)
  flutterance.writeToFile sentences, process.argv[3]
.catch (error) ->
  console.error error
  process.exit(1)
