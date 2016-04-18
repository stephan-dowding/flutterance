this.StubFragment = (function() {
  function StubFragment(sentences) {
    this.sentences = sentences;
  }

  StubFragment.prototype.expand = function() {
    return this.sentences;
  };

  return StubFragment;

})();
