flutterance = require('../flutterance')
{TreeFragment} = require('../fragments/treeFragment')

describe 'parse', ->
  it 'throws if a remainder is returned', ->
    expect(()->flutterance.parse('|hello')).to.throw(Error)

  it 'does not throw if no remainder is returned', ->
    fragment = flutterance.parse('hello')
    expect(fragment).to.be.an.instanceof(TreeFragment)

describe 'readFromFile', ->
  it 'returns an array of lines and their number', ->
    flutterance.readFromFile('test/data/file.txt')
    .then (lines) ->
      expect(lines.length).to.equal(2)
      expect(lines[0]).to.deep.equal({number: 1, text: 'Hello, this is test [line|text] 1'})
      expect(lines[1]).to.deep.equal({number: 2, text: 'Hello, this is test [line|text] 2'})
  it 'skips blank lines', ->
    flutterance.readFromFile('test/data/fileWithBlankLine.txt')
    .then (lines) ->
      expect(lines.length).to.equal(2)
      expect(lines[0]).to.deep.equal({number: 1, text: 'Hello, this is test [line|text] 1'})
      expect(lines[1]).to.deep.equal({number: 3, text: 'Hello, this is test [line|text] 3'})
  it 'rejects the promise when there is a read error', ->
    flutterance.readFromFile('test/data/fileThatDoesNotExist.txt')
    .catch (error) ->
      expect(error).to.be.defined
    .then (lines) ->
      expect(false).to.be.truthy

describe 'parseLines', ->
  it 'throws exception containing line number and original sentence on error', ->
    lines = [{number: 1, text: "Good [Morning|Afternoon"}]
    expect(->flutterance.parseLines(lines)).to.throw("Line 1: Good [Morning|Afternoon")

  xit 'throws original error on parse error', ->
    lines = [{number: 1, text: "Good [Morning|Afternoon"}]
    expect(->flutterance.parseLines(lines)).to.throw("Line 1: Good [Morning|Afternoon")

  it 'parse multiple lines correctly', ->
    lines = [{number: 1, text: "Good [Morning|Afternoon]"}, {number: 2, text: "How are you"}]
    parsedLines = flutterance.parseLines(lines)
    expect(parsedLines.length).to.equal(2)
    expect(parsedLines[0]).to.be.an.instanceOf TreeFragment
    expect(parsedLines[1]).to.be.an.instanceOf TreeFragment
