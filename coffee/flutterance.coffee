treeParser = require('./parsers/treeParser')
LineByLineReader = require('line-by-line')
fs = require('fs')
os = require('os')

@parse = (input) ->
  {fragment: fragment, remainder: remainder} = treeParser.parse(input)
  throw new Error 'unexpected | or ]' if remainder
  fragment

@readFromFile = (file) ->
  new Promise (resolve, reject) ->
    rl = new LineByLineReader file
    lines = []
    number = 0
    rl.on 'line', (line) ->
      ++number
      lines.push({number: number, text: line}) if line
    rl.on 'end', () -> resolve(lines)
    rl.on 'error', (err) -> reject(err)

@parseLines = (lines) ->
  lines.map (line) =>
    try
      @parse(line.text)
    catch error
      throw new Error("""
      Line #{line.number}: #{line.text}
      #{error}
      """)

@expandAll = (fragments) ->
  Array.from(new Set([].concat(fragment.expand() for fragment in fragments ...)))

@writeToFile = (sentences, file) ->
  fs.writeFileSync(file, sentences.join(os.EOL))
