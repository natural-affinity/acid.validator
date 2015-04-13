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
