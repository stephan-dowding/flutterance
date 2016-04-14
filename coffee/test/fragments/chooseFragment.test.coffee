{ChooseFragment} = require('../../fragments/chooseFragment')
{StubFragment} = require('./fragment.stub')

describe 'ChooseFragment', ->
  describe 'expand', ->
    it 'provides a list of each literal', ->
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 1, 1, 'ordered')
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue'])

    it 'includes blank if min is set to zero', ->
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 0, 1, 'ordered')
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue', ''])

    it 'includes multi-word combinations when max > 1', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 1, 3, 'ordered')
      expect(fragment.expand()).to.have.members([' red', ' green', ' blue', ' red green', ' red blue', ' green blue', ' red green blue'])

    it 'includes all orderings when mode is unordered', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 3, 3, 'unordered')
      expect(fragment.expand()).to.have.members([' red green blue', ' red blue green', ' green red blue', ' green blue red', ' blue red green', ' blue green red'])

    it 'includes all orderings when mode is unordered for more than 3 items', ->
      red = new StubFragment([' red'])
      green = new StubFragment([' green'])
      blue = new StubFragment([' blue'])
      yellow = new StubFragment([' yellow'])
      cyan = new StubFragment(['cyan'])
      magenta = new StubFragment([' magenta'])
      fragment = new ChooseFragment([red, green, blue, yellow, cyan, magenta], 3, 3, 'unordered')
      expect(fragment.expand().length).to.equal(120)

    it 'expands from left', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue']), new StubFragment([' yellow'])], 0, 4, 'left')
      expect(fragment.expand()).to.have.members(['', ' red', ' red green', ' red green blue', ' red green blue yellow'])

    it 'expands from right', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue']), new StubFragment([' yellow'])], 0, 4, 'right')
      expect(fragment.expand()).to.have.members(['', ' yellow', ' blue yellow', ' green blue yellow', ' red green blue yellow'])

    it 'can be nested, ~ and normal', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new ChooseFragment([new StubFragment([' blue']), new StubFragment([' yellow'])], 1, 2, 'unordered')], 1, 3, 'ordered')
      expect(fragment.expand().length).to.equal(19)

    it 'can be nested, > and <', ->
      fragment = new ChooseFragment([new StubFragment([' red']), new ChooseFragment([new StubFragment([' green']), new StubFragment([' blue'])], 0, 2, "right"), new StubFragment([' yellow'])], 1, 3, "left")
      expect(fragment.expand()).to.have.members([' red', ' red blue', ' red green blue', ' red yellow', ' red blue yellow', ' red green blue yellow'])

    describe 'returns empty array if min length is too long', ->
      it 'ordered', ->
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'ordered')
        expect(fragment.expand().length).to.equal(0)

      it 'unordered', ->
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'unordered')
        expect(fragment.expand().length).to.equal(0)

      it 'left', ->
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'left')
        expect(fragment.expand().length).to.equal(0)

      it 'right', ->
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'right')
        expect(fragment.expand().length).to.equal(0)
