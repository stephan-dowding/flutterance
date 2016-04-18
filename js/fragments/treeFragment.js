this.TreeFragment = (function() {
  function TreeFragment(left, right) {
    this.left = left;
    this.right = right;
  }

  TreeFragment.prototype.expand = function() {
    var leftItems, ref, rightItems;
    leftItems = this.left.expand();
    rightItems = this.right.expand();
    return [].concat(...leftItems.map(leftItem => rightItems.map(rightItem => leftItem + rightItem)));
  };

  return TreeFragment;

})();
