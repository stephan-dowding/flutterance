{LiteralFragment} = require('../../fragments/literalFragment')

describe 'LiteralFragment', ->
  describe 'expand', ->
    it 'provides a single item', ->
      fragment = new LiteralFragment('what is this')
      expect(fragment.expand()).to.have.members(['what is this'])
