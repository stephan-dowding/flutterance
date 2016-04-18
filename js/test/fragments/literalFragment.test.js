var LiteralFragment;

LiteralFragment = require('../../fragments/literalFragment').LiteralFragment;

describe('LiteralFragment', function() {
  return describe('expand', function() {
    return it('provides a single item', function() {
      var fragment;
      fragment = new LiteralFragment('what is this');
      return expect(fragment.expand()).to.have.members(['what is this']);
    });
  });
});
