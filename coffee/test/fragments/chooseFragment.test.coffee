{ChooseFragment} = require('../../fragments/chooseFragment')
{StubFragment} = require('./fragment.stub')

describe 'ChooseFragment', ->
  describe 'expand', ->
    it 'provides a list of each literal', ->
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])])
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue'])

    it 'includes blank if min is set to zero', ->
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 0)
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue', ''])
