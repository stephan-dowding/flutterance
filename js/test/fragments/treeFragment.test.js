var StubFragment, TreeFragment;

TreeFragment = require('../../fragments/treeFragment').TreeFragment;

StubFragment = require('./fragment.stub').StubFragment;

describe('ChooseFragment', function() {
  return describe('expand', function() {
    it('combines the literals', function() {
      var fragment;
      fragment = new TreeFragment(new StubFragment(['red ']), new StubFragment(['green']));
      return expect(fragment.expand()).to.have.members(['red green']);
    });
    it('expands when there are many left items', function() {
      var fragment, leftFragment;
      leftFragment = new StubFragment(['red', 'yellow']);
      fragment = new TreeFragment(leftFragment, new StubFragment([' green']));
      return expect(fragment.expand()).to.have.members(['red green', 'yellow green']);
    });
    it('expands when there are many right items', function() {
      var fragment, rightFragment;
      rightFragment = new StubFragment(['blue', 'green']);
      fragment = new TreeFragment(new StubFragment(['red ']), rightFragment);
      return expect(fragment.expand()).to.have.members(['red blue', 'red green']);
    });
    return it('expands when there are many left and right items', function() {
      var fragment, leftFragment, rightFragment;
      leftFragment = new StubFragment(['kind', 'calm']);
      rightFragment = new StubFragment(['er', 'ly']);
      fragment = new TreeFragment(leftFragment, rightFragment);
      return expect(fragment.expand()).to.have.members(['kindly', 'kinder', 'calmly', 'calmer']);
    });
  });
});
