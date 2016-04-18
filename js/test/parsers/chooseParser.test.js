var chooseParser;

chooseParser = require('../../parsers/chooseParser');

describe('chooseParser', function() {
  it('throws if input does not start with [', function() {
    return expect(function() {
      return chooseParser.parse('hello');
    }).to["throw"]('unexpected input');
  });
  it('throws if [ and ] are unmatched', function() {
    return expect(function() {
      return chooseParser.parse('[hello');
    }).to["throw"]('missing ] after [');
  });
  it('creates a choose fragment with a single option', function() {
    var fragment, ref, remainder;
    ref = chooseParser.parse('[hello]'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.choices.length).to.equal(1);
    expect(fragment.expand()).to.have.members(['hello']);
    return expect(remainder).to.be.falsey;
  });
  it('creates a choose fragment with a multiple option', function() {
    var fragment, ref, remainder;
    ref = chooseParser.parse('[hello|hi|hey]'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.choices.length).to.equal(3);
    expect(fragment.expand()).to.have.members(['hello', 'hi', 'hey']);
    return expect(remainder).to.be.falsey;
  });
  it('returns the remainder', function() {
    var fragment, ref, remainder;
    ref = chooseParser.parse('[hello|hi|hey] how are you'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.choices.length).to.equal(3);
    return expect(remainder).to.equal(' how are you');
  });
  it('sets the min to 1', function() {
    var fragment, ref, remainder;
    ref = chooseParser.parse('[hello|hi|hey] how are you'), fragment = ref.fragment, remainder = ref.remainder;
    expect(fragment.min).to.equal(1);
    expect(fragment.max).to.equal(1);
    return expect(fragment.mode).to.equal('ordered');
  });
  describe('?', function() {
    it('sets the min to 0', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]? how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(0);
      expect(fragment.max).to.equal(1);
      return expect(fragment.mode).to.equal('ordered');
    });
    return it('returns the remainder', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]? how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
  });
  describe('+', function() {
    it('sets the max to choices.length', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]+ how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(1);
      expect(fragment.max).to.equal(3);
      return expect(fragment.mode).to.equal('ordered');
    });
    return it('returns the remainder', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]+ how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
  });
  describe('*', function() {
    it('sets the min to 0 and max to choices.length', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]* how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(0);
      expect(fragment.max).to.equal(3);
      return expect(fragment.mode).to.equal('ordered');
    });
    return it('returns the remainder', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]* how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
  });
  describe('(n)', function() {
    it('sets the min and max to n', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey](2) how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(2);
      expect(fragment.max).to.equal(2);
      return expect(fragment.mode).to.equal('ordered');
    });
    it('sets the min and max to maxLength for *', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey](*) how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(3);
      expect(fragment.max).to.equal(3);
      return expect(fragment.mode).to.equal('ordered');
    });
    it('returns the remainder for (n)', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey](2) how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
    return it('throws a meaningful error if it can\'t parse the input', function() {
      return expect(function() {
        return chooseParser.parse('[hello|hi|hey](two) how are you');
      }).to["throw"]('invalid format after \'(\'...\nit should be (n) or (n,m) where n and m are an integer or *');
    });
  });
  describe('(n,m)', function() {
    it('sets the min and max to n and m', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey|yo|wassup](2, 4) how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(2);
      expect(fragment.max).to.equal(4);
      return expect(fragment.mode).to.equal('ordered');
    });
    it('sets the min and max to maxLength for *', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey|yo|wassup](2,*) how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(2);
      expect(fragment.max).to.equal(5);
      return expect(fragment.mode).to.equal('ordered');
    });
    it('returns the remainder for (n,m)', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey](2,*) how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
    return it('throws a meaningful error if it can\'t parse the input', function() {
      return expect(function() {
        return chooseParser.parse('[hello|hi|hey](1,two) how are you');
      }).to["throw"]('invalid format after \'(\'...\nit should be (n) or (n,m) where n and m are an integer or *');
    });
  });
  describe('~', function() {
    it('sets the mode to unordered', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]~ how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(1);
      expect(fragment.max).to.equal(1);
      return expect(fragment.mode).to.equal('unordered');
    });
    it('returns the remainder', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]~ how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
    return it('can combine with *', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]~* how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(0);
      expect(fragment.max).to.equal(3);
      expect(fragment.mode).to.equal('unordered');
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
  });
  describe('>', function() {
    it('sets the mode to unordered', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]> how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(1);
      expect(fragment.max).to.equal(1);
      return expect(fragment.mode).to.equal('left');
    });
    it('returns the remainder', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]> how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
    return it('can combine with *', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]>* how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(0);
      expect(fragment.max).to.equal(3);
      expect(fragment.mode).to.equal('left');
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
  });
  return describe('<', function() {
    it('sets the mode to unordered', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]< how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(1);
      expect(fragment.max).to.equal(1);
      return expect(fragment.mode).to.equal('right');
    });
    it('returns the remainder', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]< how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
    return it('can combine with *', function() {
      var fragment, ref, remainder;
      ref = chooseParser.parse('[hello|hi|hey]<* how are you'), fragment = ref.fragment, remainder = ref.remainder;
      expect(fragment.min).to.equal(0);
      expect(fragment.max).to.equal(3);
      expect(fragment.mode).to.equal('right');
      expect(fragment.choices.length).to.equal(3);
      return expect(remainder).to.equal(' how are you');
    });
  });
});
