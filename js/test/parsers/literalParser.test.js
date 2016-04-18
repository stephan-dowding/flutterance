var literalParser;

literalParser = require('../../parsers/literalParser');

describe('literalParser', function() {
  it('stops at the end of the string', function() {
    var fragment, ref, remainder;
    ref = literalParser.parse('Hello'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.literal).to.equal('Hello');
    return expect(remainder).to.be.falsey;
  });
  it('stops on [', function() {
    var fragment, ref, remainder;
    ref = literalParser.parse('Good [Morning|Afternoon]'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.literal).to.equal('Good ');
    return expect(remainder).to.equal('[Morning|Afternoon]');
  });
  it('stops on |', function() {
    var fragment, ref, remainder;
    ref = literalParser.parse('Morning|Afternoon]'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.literal).to.equal('Morning');
    return expect(remainder).to.equal('|Afternoon]');
  });
  return it('stops on ]', function() {
    var fragment, ref, remainder;
    ref = literalParser.parse('Afternoon] how are you'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.literal).to.equal('Afternoon');
    return expect(remainder).to.equal('] how are you');
  });
});
