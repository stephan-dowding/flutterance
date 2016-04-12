flutterance = require('../flutterance')
{TreeFragment} = require('../fragments/treeFragment')
{StubFragment} = require('./fragments/fragment.stub')
fs = require('fs')
os = require('os')

describe 'flutterance', ->
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

    it 'throws original error on parse error', ->
      lines = [{number: 1, text: "Good [Morning|Afternoon"}]
      expect(->flutterance.parseLines(lines)).to.throw("Error: missing ] after [")

    it 'parse multiple lines correctly', ->
      lines = [{number: 1, text: "Good [Morning|Afternoon]"}, {number: 2, text: "How are you"}]
      parsedLines = flutterance.parseLines(lines)
      expect(parsedLines.length).to.equal(2)
      expect(parsedLines[0]).to.be.an.instanceOf TreeFragment
      expect(parsedLines[1]).to.be.an.instanceOf TreeFragment

  describe 'expandAll', ->
    it 'expands all the fragments into an array of sentences', ->
      fragments = [new StubFragment(['Sentence 1','Sentence 2']), new StubFragment(['Sentence 3', 'Sentence 4'])]
      expect(flutterance.expandAll(fragments)).to.have.members ['Sentence 1','Sentence 2', 'Sentence 3', 'Sentence 4']

    it 'removes duplicates', ->
      fragments = [new StubFragment(['Sentence 1','Sentence 2']), new StubFragment(['Sentence 2', 'Sentence 3'])]
      sentences = flutterance.expandAll(fragments)
      expect(sentences.length).to.equal(3)
      expect(sentences).to.have.members ['Sentence 1','Sentence 2', 'Sentence 3']

  describe 'writeToFile', ->
    testFile = 'test/data/utterances.txt'
    it 'writes each sentence as a line in the file', ->
      flutterance.writeToFile(['Sentence 1', 'Sentence 2'], testFile)
      expect(-> fs.accessSync(testFile, fs.F_OK)).not.to.throw Error
      expect(fs.readFileSync(testFile, 'utf8')).to.equal("Sentence 1#{os.EOL}Sentence 2")

    afterEach ->
      try
        fs.unlinkSync testFile
      catch error