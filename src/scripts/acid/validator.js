/*global _ */
'use strict';
var Acid = Acid || {};
Acid.Mixins = Acid.Mixins || {};
Acid.Mixins.Validation = Acid.Mixins.Validation || {};
Acid.Mixins.Validation.Rules = Acid.Mixins.Validation.Rules || {};

Acid.Validator = function(rules) {
  var _data = null;
  var _result = true;
  var _rules = rules || Acid.Mixins.Validation.Rules;
  this.using = this;

  this.data = function() {
    return _data;
  };

  this.verify = function(data) {
    _data = data;
    return this;
  };

  this.rule = function(rule) {
    var key = _.first(_.keys(rule));
    var hasKey = _.isString(key);
    var val = hasKey ? rule[key] : null;

    if (hasKey === true) {
      var result = _rules[key](_data, val);

      if (_result === true && result === false) {
        _result = false;
      }// set to false on first failure
    }

    return this;
  };

  this.result = function() {
    var temp = _result;
    _result = true;

    return temp;
  };

  return {
    verify: this.verify,
    data: this.data,
    using: this.using,
    rule: this.rule,
    result: this.result
  };
};