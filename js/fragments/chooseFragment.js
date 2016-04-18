this.ChooseFragment = (function() {
  var flatten, remove;

  function ChooseFragment(choices, min, max, mode) {
    this.choices = choices;
    this.min = min <= max ? min : max;
    this.max = min <= max ? max : min;
    this.mode = mode;
  }

  ChooseFragment.prototype.expand = function() {
    var results = [];
    for (var j = this.min; j <= this.max; j++){
      results = results.concat(this.expandX(j,this.choices));
    }
    return results;
  };

  ChooseFragment.prototype.expandX = function(n, choices) {
    if (n > choices.length) { return []; }
    if (n === 0) { return ['']; }

    var result
    if (this.mode === 'left') {
      result = this.expandX(n - 1, choices.slice(1))
        .map(end => choices[0].expand()
          .map(start => start + end)
        );
    }
    else if (this.mode === 'right') {
      result = this.expandX(n - 1, choices.slice(0, -1))
        .map(start => choices[choices.length - 1].expand()
          .map(end => start + end)
        );
    }
    else if (n === 1) {
      result = choices.map(choice => choice.expand());
    }
    else if (this.mode === 'unordered') {
      result = choices.map((startElem, i) => this.expandX(n - 1, remove(choices, i))
        .map(end => startElem.expand()
          .map(start => start + end)
        )
      );
    }
    else {
      result = this.expandX(n, choices.slice(1))
        .concat(this.expandX(n - 1, choices.slice(1))
          .map(end => choices[0].expand()
            .map(start => start + end)
          )
        );
    }

    return flatten(result);
  };

  remove = function(arr, i) {
    var temp = arr.slice(0);
    temp.splice(i, 1);
    return temp;
  };

  flatten = function(arr) {
    return arr.reduce((flat, toFlatten) => flat.concat(Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten), []);
  };

  return ChooseFragment;

})();
