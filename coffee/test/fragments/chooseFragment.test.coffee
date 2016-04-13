{ChooseFragment} = require('../../fragments/chooseFragment')
{StubFragment} = require('./fragment.stub')

describe 'ChooseFragment', ->
  describe 'expand', ->
    it 'provides a list of each literal', ->
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 1, 1)
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue'])

    it 'includes blank if min is set to zero', ->
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 0, 1)
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue', ''])

    it 'includes multi-word combinations when max > 1', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 1, 3)
      expect(fragment.expand()).to.have.members([' red', ' green', ' blue', ' red green', ' red blue', ' green blue', ' red green blue'])

    it 'includes all orderings when mode is unordered', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 3, 3, "unordered")
      expect(fragment.expand()).to.have.members([' red green blue', ' red blue green', ' green red blue', ' green blue red', ' blue red green', ' blue green red'])

    it 'includes all orderings when mode is unordered for more than 3 items', ->
      red = new StubFragment([' red'])
      green = new StubFragment([' green'])
      blue = new StubFragment([' blue'])
      yellow = new StubFragment([' yellow'])
      cyan = new StubFragment(['cyan'])
      magenta = new StubFragment([' magenta'])
      fragment = new ChooseFragment([red, green, blue, yellow, cyan, magenta], 3, 3, "unordered")
      expect(fragment.expand().length).to.equal(120)

    it 'expands from left', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue']), new StubFragment([' yellow'])], 0, 4, "left")
      expect(fragment.expand()).to.have.members(['', ' red', ' red green', ' red green blue', ' red green blue yellow'])

    it 'expands from right', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue']), new StubFragment([' yellow'])], 0, 4, "right")
      expect(fragment.expand()).to.have.members(['', ' yellow', ' blue yellow', ' green blue yellow', ' red green blue yellow'])
