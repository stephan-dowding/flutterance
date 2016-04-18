var ChooseFragment, StubFragment;

ChooseFragment = require('../../fragments/chooseFragment').ChooseFragment;

StubFragment = require('./fragment.stub').StubFragment;

describe('ChooseFragment', function() {
  return describe('expand', function() {
    it('provides a list of each literal', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 1, 1, 'ordered');
      return expect(fragment.expand()).to.have.members(['red', 'green', 'blue']);
    });
    it('includes blank if min is set to zero', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment(['red']), new StubFragment(['green']), new StubFragment(['blue'])], 0, 1, 'ordered');
      return expect(fragment.expand()).to.have.members(['red', 'green', 'blue', '']);
    });
    it('includes multi-word combinations when max > 1', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 1, 3, 'ordered');
      return expect(fragment.expand()).to.have.members([' red', ' green', ' blue', ' red green', ' red blue', ' green blue', ' red green blue']);
    });
    it('includes all orderings when mode is unordered', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 3, 3, 'unordered');
      return expect(fragment.expand()).to.have.members([' red green blue', ' red blue green', ' green red blue', ' green blue red', ' blue red green', ' blue green red']);
    });
    it('includes all orderings when mode is unordered for more than 3 items', function() {
      var blue, cyan, fragment, green, magenta, red, yellow;
      red = new StubFragment([' red']);
      green = new StubFragment([' green']);
      blue = new StubFragment([' blue']);
      yellow = new StubFragment([' yellow']);
      cyan = new StubFragment(['cyan']);
      magenta = new StubFragment([' magenta']);
      fragment = new ChooseFragment([red, green, blue, yellow, cyan, magenta], 3, 3, 'unordered');
      return expect(fragment.expand().length).to.equal(120);
    });
    it('expands from left', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue']), new StubFragment([' yellow'])], 0, 4, 'left');
      return expect(fragment.expand()).to.have.members(['', ' red', ' red green', ' red green blue', ' red green blue yellow']);
    });
    it('expands from right', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue']), new StubFragment([' yellow'])], 0, 4, 'right');
      return expect(fragment.expand()).to.have.members(['', ' yellow', ' blue yellow', ' green blue yellow', ' red green blue yellow']);
    });
    it('can be nested, ~ and normal', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new ChooseFragment([new StubFragment([' blue']), new StubFragment([' yellow'])], 1, 2, 'unordered')], 1, 3, 'ordered');
      return expect(fragment.expand().length).to.equal(19);
    });
    it('can be nested, > and <', function() {
      var fragment;
      fragment = new ChooseFragment([new StubFragment([' red']), new ChooseFragment([new StubFragment([' green']), new StubFragment([' blue'])], 0, 2, "right"), new StubFragment([' yellow'])], 1, 3, "left");
      return expect(fragment.expand()).to.have.members([' red', ' red blue', ' red green blue', ' red yellow', ' red blue yellow', ' red green blue yellow']);
    });
    return describe('returns empty array if min length is too long', function() {
      it('ordered', function() {
        var fragment;
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'ordered');
        return expect(fragment.expand().length).to.equal(0);
      });
      it('unordered', function() {
        var fragment;
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'unordered');
        return expect(fragment.expand().length).to.equal(0);
      });
      it('left', function() {
        var fragment;
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'left');
        return expect(fragment.expand().length).to.equal(0);
      });
      return it('right', function() {
        var fragment;
        fragment = new ChooseFragment([new StubFragment([' red']), new StubFragment([' green']), new StubFragment([' blue'])], 6, 6, 'right');
        return expect(fragment.expand().length).to.equal(0);
      });
    });
  });
});
