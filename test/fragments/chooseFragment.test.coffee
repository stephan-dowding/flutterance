{ChooseFragment} = require('../../fragments/chooseFragment')
{LiteralFragment} = require('../../fragments/literalFragment')

describe 'ChooseFragment', ->
  describe 'expand', ->
    it 'provides a list of each literal', ->
      fragment = new ChooseFragment([new LiteralFragment('red'), new LiteralFragment('green'), new LiteralFragment('blue')])
      expect(fragment.expand()).to.have.members(['red', 'green', 'blue'])
