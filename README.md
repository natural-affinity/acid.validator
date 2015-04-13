acid.validator
==============

Skeleton framework for client-side validation.

Prerequisites
-------------
* Node.js (v0.10.3x)

Features
--------
* Chainable API
* Mixin

Project Structure
-----------------
<pre>
/
|-- bower.json: runtime and dev dependencies (underscore, jasmine)
|-- package.json: build dependencies (grunt plugins)
|-- Gruntfile.js: all grunt build, deploy, compile, serve tasks
|-- dist: deployment-ready assets
|-- test: test-ready assets
|-- spec: all component test code
    |-- scripts (coffeescript assets)
|-- src: all component code
    |-- scripts (javascript assets)
        |-- acid (ACID Validator Component)
        |-- mixins (ACID Validation Mixin with Rules)

</pre>

Usage and Documentation
-----------------------
Please ensure all dependencies have been installed prior to usage.

### Setup

Switch to the project root directory and run the `setup.sh` script (`setup.bat` for Windows):  
```bash
$ cd acid.validator
$ ./bin/setup.sh
```

### Workflow

The `grunt serve` (watch, build, test) loop is designed to accelerate development workflow:
```bash
$ grunt serve
```

Alternatively, to simply build the component, invoke:
```bash
$ grunt build
```

Alternatively, to build and execute all component tests, invoke:
```bash
$ grunt test
```

### Usage: Standalone
```javascript
//Create Validator and inject existing rules from mixin
var validator = new Acid.Validator(Acid.Mixins.Validation.Rules);

//Validate data using rules and capture the result of the rules chain
var result = validator.verify('data').using.rule({length: 5}).rule({minLength: 1}).result();
```

### Usage: Mixin
```javascript
var validator = {};

//Extend your object (or prototype) with mixin depending on your requirements
_.extend(validator, Acid.Mixins.Validation);

//Evaluate using validation mixin (rules are directly accessible under the Rules namespace)
var result = validator.verify('data', {minLength: 4, length: 4});
```

### Usage: Backbone (Standalone)
```javascript
Acid.Models.MyModel = Backbone.Model.extend({
  defaults: {
    emailAddress: ''
  },
  initialize: function (options) {
    options = _.defaults(options || {}, {validator: (new Acid.Validator())});
    this.validator = options.validator;
  },
  validate: function (attributes) {
    var errors = [];

    //setup rule for email
    this.validator.verify(attributes.emailAddress).using.rule({minLength: 1});

    if (!this.validator.result()) {
      this.trigger('invalid:email');
      errors.push({field: 'emailAddress', msg: 'cannot be blank'});
    }//execute rule and reset validator

    return (errors.length > 0 ? errors : false);
  }
});
```

### Usage: Backbone (Mixin) 
```javascript
Acid.Models.MyModel = Backbone.Model.extend({
  defaults: {
    emailAddress: ''
  },
  initialize: function (options) {

  },
  validate: function (attributes) {
    var errors = [];

    if (!this.verify.call(this, attributes.emailAddress, {minLength: 1, length: 1})) {
      this.trigger('invalid:email');
      errors.push({field: 'emailAddress', msg: 'cannot be blank'});
    }

    return (errors.length > 0 ? errors : false);
  }
});

_.extend(Acid.Models.MyModel.prototype, Acid.Mixins.Validation);
```
