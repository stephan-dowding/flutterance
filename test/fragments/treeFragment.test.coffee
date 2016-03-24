{TreeFragment} = require('../../fragments/treeFragment')
{LiteralFragment} = require('../../fragments/literalFragment')
{NullFragment} = require('../../fragments/nullFragment')
{ChooseFragment} = require('../../fragments/chooseFragment')

describe 'ChooseFragment', ->
  describe 'expand', ->
    it 'combines the literals', ->
      fragment = new TreeFragment(new LiteralFragment('red'), new LiteralFragment('green'))
      expect(fragment.expand()).to.have.members(['red green'])

    it 'does not leave a trailing space', ->
      fragment = new TreeFragment(new LiteralFragment('red'), new NullFragment)
      expect(fragment.expand()).to.have.members(['red'])

    it 'expands when there are many left items', ->
      leftFragment = new ChooseFragment([new LiteralFragment('red'), new LiteralFragment('yellow')])
      fragment = new TreeFragment(leftFragment, new LiteralFragment('green'))
      expect(fragment.expand()).to.have.members(['red green', 'yellow green'])

    it 'expands when there are many right items', ->
      rightFragment = new ChooseFragment([new LiteralFragment('blue'), new LiteralFragment('green')])
      fragment = new TreeFragment(new LiteralFragment('red'), rightFragment)
      expect(fragment.expand()).to.have.members(['red blue', 'red green'])

    it 'expands when there are many left and right items', ->
      leftFragment = new ChooseFragment([new LiteralFragment('red'), new LiteralFragment('yellow')])
      rightFragment = new ChooseFragment([new LiteralFragment('blue'), new LiteralFragment('green')])
      fragment = new TreeFragment(leftFragment, rightFragment)
      expect(fragment.expand()).to.have.members(['red green', 'yellow green', 'red blue', 'yellow blue'])
