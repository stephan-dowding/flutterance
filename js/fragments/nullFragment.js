this.NullFragment = (function() {
  function NullFragment() {}

  NullFragment.prototype.expand = function() {
    return [''];
  };

  return NullFragment;

})();
