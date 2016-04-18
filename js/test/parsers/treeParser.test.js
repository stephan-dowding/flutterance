var ChooseFragment, LiteralFragment, NullFragment, TreeFragment, treeParser;

treeParser = require('../../parsers/treeParser');

NullFragment = require('../../fragments/nullFragment').NullFragment;

LiteralFragment = require('../../fragments/literalFragment').LiteralFragment;

ChooseFragment = require('../../fragments/chooseFragment').ChooseFragment;

TreeFragment = require('../../fragments/treeFragment').TreeFragment;

describe('treeParser', function() {
  it('returns a nullFragment for empty string', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse(''), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment).to.be.an["instanceof"](NullFragment);
    return expect(remainder).to.be.falsey;
  });
  it('returns a nullFragment for a string starting |', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse('|something'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment).to.be.an["instanceof"](NullFragment);
    return expect(remainder).to.equal('|something');
  });
  it('returns a nullFragment for a string starting ]', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse(']something'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment).to.be.an["instanceof"](NullFragment);
    return expect(remainder).to.equal(']something');
  });
  it('returns a treeFragment with a literal and nullFragment for a regular string', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse('something'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.left).to.be["instanceof"](LiteralFragment);
    expect(fragment.right).to.be["instanceof"](NullFragment);
    return expect(remainder).to.be.falsey;
  });
  it('returns a treeFragment with a literal, nullFragment and remainder for a | terminated string', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse('some|thing'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.left).to.be["instanceof"](LiteralFragment);
    expect(fragment.right).to.be["instanceof"](NullFragment);
    return expect(remainder).to.equal('|thing');
  });
  it('returns a treeFragment with a chooseFragment and nullFragment', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse('[some|thing]'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.left).to.be["instanceof"](ChooseFragment);
    expect(fragment.right).to.be["instanceof"](NullFragment);
    return expect(remainder).to.be.falsey;
  });
  it('returns a treeFragment with a chooseFragment and treeFragment', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse('[some|thing] else'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.left).to.be["instanceof"](ChooseFragment);
    expect(fragment.right).to.be["instanceof"](TreeFragment);
    return expect(remainder).to.be.falsey;
  });
  return it('returns a treeFragment with a chooseFragment and nullFragment with remainder', function() {
    var fragment, ref, remainder;
    ref = treeParser.parse('[some|thing]|boo'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.left).to.be["instanceof"](ChooseFragment);
    expect(fragment.right).to.be["instanceof"](NullFragment);
    return expect(remainder).to.equal('|boo');
  });
});
