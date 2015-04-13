/*global _ */
'use strict';
var Acid = Acid || {};
Acid.Mixins = Acid.Mixins || {};

Acid.Mixins.Validation = {
  Rules: {
    length: function (data, len) {
      return _.isString(data) && data.length === len;
    },
    minLength: function (data, len) {
      return _.isString(data) && data.length >= len;
    }
  },
  verify: function (data, rules, ignore) {
    var keys = null,
        count = null;

    if (!_.isObject(rules)) {
      return false;
    }

    keys = _.keys(rules); //fetch own keys
    count = keys.length;

    for (var i = 0; i < count; i++) {
      var rule = keys[i];
      var args = rules[rule];
      var result = this.Rules[rule](data, args);

      if(result === false) {
        return false;
      }// exit on first failure
    }// execute each rule

    return true;
  }
};