this.LiteralFragment = (function() {
  function LiteralFragment(literal) {
    this.literal = literal;
  }

  LiteralFragment.prototype.expand = function() {
    return [this.literal];
  };

  return LiteralFragment;

})();
