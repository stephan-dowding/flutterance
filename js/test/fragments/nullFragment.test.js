var NullFragment;

NullFragment = require('../../fragments/nullFragment').NullFragment;

describe('NullFragment', function() {
  return describe('expand', function() {
    return it('provides a single empty item', function() {
      var fragment;
      fragment = new NullFragment;
      return expect(fragment.expand()).to.have.members(['']);
    });
  });
});
