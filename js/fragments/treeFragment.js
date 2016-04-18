this.TreeFragment = (function() {
  function TreeFragment(left, right) {
    this.left = left;
    this.right = right;
  }

  TreeFragment.prototype.expand = function() {
    var leftItems, ref, rightItems;
    leftItems = this.left.expand();
    rightItems = this.right.expand();
    return (ref = []).concat.apply(ref, leftItems.map(function(leftItem) {
      return rightItems.map(function(rightItem) {
        return leftItem + rightItem;
      });
    }));
  };

  return TreeFragment;

})();
