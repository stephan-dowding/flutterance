var StubFragment, TreeFragment, flutterance, fs, os;

flutterance = require('../flutterance');

TreeFragment = require('../fragments/treeFragment').TreeFragment;

StubFragment = require('./fragments/fragment.stub').StubFragment;

fs = require('fs');

os = require('os');

describe('flutterance', function() {
  describe('parse', function() {
    it('throws if a remainder is returned', function() {
      expect(function() {
        flutterance.parse('|hello');
      }).to["throw"](Error);
    });
    return it('does not throw if no remainder is returned', function() {
      var fragment = flutterance.parse('hello');
      expect(fragment).to.be.an["instanceof"](TreeFragment);
    });
  });
  describe('readFromFile', function() {
    it('returns an array of lines and their number', function() {
      flutterance.readFromFile('test/data/file.txt').then(function(lines) {
        expect(lines.length).to.equal(2);
        expect(lines[0]).to.deep.equal({
          number: 1,
          text: 'Hello, this is test [line|text] 1'
        });
        expect(lines[1]).to.deep.equal({
          number: 2,
          text: 'Hello, this is test [line|text] 2'
        });
      });
    });
    it('skips blank lines', function() {
      flutterance.readFromFile('test/data/fileWithBlankLine.txt').then(function(lines) {
        expect(lines.length).to.equal(2);
        expect(lines[0]).to.deep.equal({
          number: 1,
          text: 'Hello, this is test [line|text] 1'
        });
        expect(lines[1]).to.deep.equal({
          number: 3,
          text: 'Hello, this is test [line|text] 3'
        });
      });
    });
    it('rejects the promise when there is a read error', function() {
      flutterance.readFromFile('test/data/fileThatDoesNotExist.txt')["catch"](function(error) {
        expect(error).to.be.defined;
      }).then(function(lines) {
        expect(false).to.be.truthy;
      });
    });
  });
  describe('parseLines', function() {
    it('throws exception containing line number and original sentence on error', function() {
      var lines;
      lines = [
        {
          number: 1,
          text: "Good [Morning|Afternoon"
        }
      ];
      expect(function() {
        flutterance.parseLines(lines);
      }).to["throw"]("Line 1: Good [Morning|Afternoon");
    });
    it('throws original error on parse error', function() {
      var lines;
      lines = [
        {
          number: 1,
          text: "Good [Morning|Afternoon"
        }
      ];
      expect(function() {
        flutterance.parseLines(lines);
      }).to["throw"]("Error: missing ] after [");
    });
    it('parse multiple lines correctly', function() {
      var lines, parsedLines;
      lines = [
        {
          number: 1,
          text: "Good [Morning|Afternoon]"
        }, {
          number: 2,
          text: "How are you"
        }
      ];
      parsedLines = flutterance.parseLines(lines);
      expect(parsedLines.length).to.equal(2);
      expect(parsedLines[0]).to.be.an.instanceOf(TreeFragment);
      expect(parsedLines[1]).to.be.an.instanceOf(TreeFragment);
    });
  });
  describe('expandAll', function() {
    it('expands all the fragments into an array of sentences', function() {
      var fragments;
      fragments = [new StubFragment(['Sentence 1', 'Sentence 2']), new StubFragment(['Sentence 3', 'Sentence 4'])];
      expect(flutterance.expandAll(fragments)).to.have.members(['Sentence 1', 'Sentence 2', 'Sentence 3', 'Sentence 4']);
    });
    it('removes duplicates', function() {
      var fragments, sentences;
      fragments = [new StubFragment(['Sentence 1', 'Sentence 2']), new StubFragment(['Sentence 2', 'Sentence 3'])];
      sentences = flutterance.expandAll(fragments);
      expect(sentences.length).to.equal(3);
      expect(sentences).to.have.members(['Sentence 1', 'Sentence 2', 'Sentence 3']);
    });
    it('normalises spaces', function() {
      var fragments, sentences;
      fragments = [new StubFragment(['Sentence 1', 'Sentence  2']), new StubFragment(['Sentence   3', 'Sentence    4'])];
      sentences = flutterance.expandAll(fragments);
      expect(sentences.length).to.equal(4);
      expect(sentences).to.have.members(['Sentence 1', 'Sentence 2', 'Sentence 3', 'Sentence 4']);
    });
    it('trims sentences', function() {
      var fragments, sentences;
      fragments = [new StubFragment(['Sentence 1', ' Sentence 2']), new StubFragment(['Sentence 3 ', ' Sentence 4 '])];
      sentences = flutterance.expandAll(fragments);
      expect(sentences.length).to.equal(4);
      expect(sentences).to.have.members(['Sentence 1', 'Sentence 2', 'Sentence 3', 'Sentence 4']);
    });
  });
  describe('writeToFile', function() {
    var testFile;
    testFile = 'test/data/utterances.txt';
    it('writes each sentence as a line in the file', function() {
      flutterance.writeToFile(['Sentence 1', 'Sentence 2'], testFile);
      expect(function() {
        fs.accessSync(testFile, fs.F_OK);
      }).not.to["throw"](Error);
      expect(fs.readFileSync(testFile, 'utf8')).to.equal("Sentence 1" + os.EOL + "Sentence 2");
    });
    afterEach(function() {
      var error, error1;
      try {
        fs.unlinkSync(testFile);
      } catch (error1) {
        error = error1;
      }
    });
  });
});
