this.ChooseFragment = (function() {
  var flatten, remove;

  function ChooseFragment(choices1, min, max, mode) {
    this.choices = choices1;
    this.min = min;
    this.max = max;
    this.mode = mode;
  }

  ChooseFragment.prototype.expand = function() {
    var j, ref, ref1, results;
    return flatten((function() {
      results = [];
      for (var j = ref = this.min, ref1 = this.max; ref <= ref1 ? j <= ref1 : j >= ref1; ref <= ref1 ? j++ : j--){ results.push(j); }
      return results;
    }).apply(this).map((function(_this) {
      return function(n) {
        return _this.expandX(n, _this.choices);
      };
    })(this)));
  };

  ChooseFragment.prototype.expandX = function(n, choices) {
    if (n > choices.length) {
      return [];
    }
    if (n === 0) {
      return [''];
    }
    if (this.mode === 'left') {
      return flatten(this.expandX(n - 1, choices.slice(1)).map(function(end) {
        return choices[0].expand().map(function(start) {
          return "" + start + end;
        });
      }));
    }
    if (this.mode === 'right') {
      return flatten(this.expandX(n - 1, choices.slice(0, -1)).map(function(start) {
        return choices[choices.length - 1].expand().map(function(end) {
          return "" + start + end;
        });
      }));
    }
    if (n === 1) {
      return flatten(choices.map(function(choice) {
        return choice.expand();
      }));
    }
    if (this.mode !== 'unordered') {
      return flatten(this.expandX(n, choices.slice(1)).concat(this.expandX(n - 1, choices.slice(1)).map(function(end) {
        return choices[0].expand().map(function(start) {
          return "" + start + end;
        });
      })));
    }
    return flatten(choices.map((function(_this) {
      return function(startElem, i) {
        return _this.expandX(n - 1, remove(choices, i)).map(function(end) {
          return startElem.expand().map(function(start) {
            return "" + start + end;
          });
        });
      };
    })(this)));
  };

  remove = function(arr, i) {
    var temp;
    temp = arr.slice(0);
    temp.splice(i, 1);
    return temp;
  };

  flatten = function(arr) {
    return arr.reduce(function(flat, toFlatten) {
      var items;
      items = Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten;
      return flat.concat(items);
    }, []);
  };

  return ChooseFragment;

})();
