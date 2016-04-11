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
