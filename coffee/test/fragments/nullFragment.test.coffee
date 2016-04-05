{NullFragment} = require('../../fragments/nullFragment')

describe 'NullFragment', ->
  describe 'expand', ->
    it 'provides a single empty item', ->
      fragment = new NullFragment
      expect(fragment.expand()).to.have.members([''])
