{TreeFragment} = require('../../fragments/treeFragment')
{StubFragment} = require('./fragment.stub')

describe 'ChooseFragment', ->
  describe 'expand', ->
    it 'combines the literals', ->
      fragment = new TreeFragment(new StubFragment(['red ']), new StubFragment(['green']))
      expect(fragment.expand()).to.have.members(['red green'])

    it 'expands when there are many left items', ->
      leftFragment = new StubFragment(['red', 'yellow'])
      fragment = new TreeFragment(leftFragment, new StubFragment([' green']))
      expect(fragment.expand()).to.have.members(['red green', 'yellow green'])

    it 'expands when there are many right items', ->
      rightFragment = new StubFragment(['blue', 'green'])
      fragment = new TreeFragment(new StubFragment(['red ']), rightFragment)
      expect(fragment.expand()).to.have.members(['red blue', 'red green'])

    it 'expands when there are many left and right items', ->
      leftFragment = new StubFragment(['kind', 'calm'])
      rightFragment = new StubFragment(['er', 'ly'])
      fragment = new TreeFragment(leftFragment, rightFragment)
      expect(fragment.expand()).to.have.members(['kindly', 'kinder', 'calmly', 'calmer'])
