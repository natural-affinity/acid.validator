describe 'Validation', ->
  describe 'Dependencies', ->
    it 'requires underscore.js', -> expect(_).toBeDefined()

  describe 'Namespaces', ->
    it 'requires Acid', -> expect(Acid).toBeDefined()
    it 'requires Acid.Mixins', -> expect(Acid.Mixins).toBeDefined()
    it 'requires Acid.Mixins.Validation', -> expect(Acid.Mixins.Validation).toBeDefined()
    it 'requires Acid.Mixins.Validation.Rules', -> expect(Acid.Mixins.Validation.Rules).toBeDefined()

  describe 'Rules', ->
    validator = Acid.Mixins.Validation
    rules = validator.Rules

    describe '#length', ->
      it 'allows untrimmed strings', -> expect(rules.length '   ', 3).toBe true
      it 'rejects numbers', -> expect(rules.length 1, 10).toBe false
      it 'rejects undefined', -> expect(rules.length undefined, 20).toBe false
      it 'rejects objects', -> expect(rules.length {}, 20).toBe false
      it 'rejects arrays', -> expect(rules.length [], 20).toBe false
      it 'rejects null', -> expect(rules.length null, 20).toBe false
      it 'ensures exact length', -> expect(rules.length 'abc', 3).toBe true
      it 'ensures exact length (invalid)', -> expect(rules.length 'abc', 4).toBe false

    describe '#minLength', ->
      it 'allows un-trimmed strings', -> expect(rules.minLength '   ', 1).toBe true
      it 'ensures minimum length', -> expect(rules.minLength 'abc', 1).toBe true
      it 'ensures minimum length (inclusive)', -> expect(rules.minLength 'abc', 3).toBe true
      it 'ensures minimum length (invalid)', -> expect(rules.minLength 'abc', 4).toBe false

    describe '#verify', ->
      it 'accepts a hash of rules', ->
        spyOn validator, 'verify'
        validator.verify 'data', {}
        expect(validator.verify).toHaveBeenCalledWith 'data', {}
      it 'passes if all rules are satisfied', -> expect(validator.verify 'a', {length: 1, minLength: 1}).toBe true
      it 'terminates on the first failing rule', -> expect(validator.verify 'a', {length: 2, minLength: 1}).toBe false
      it 'rejects invalid rules', -> expect(-> validator.verify 'data', {invalidRule: 10}).toThrow()

  describe 'Validator', ->
    rules = Acid.Mixins.Validation.Rules

    it 'hides mixin operations', -> expect(-> (new Acid.Validator rules).length()).toThrow()
    it 'includes the default mixin if none is injected', ->
      instance = new Acid.Validator()
      expect(instance.verify('data').using.rule({length: 4}).result()).toBe true

    describe '.using', ->
      validator = new Acid.Validator()
      it 'exists', -> expect(validator.using).toBeDefined()
      it 'is chainable', -> expect(validator.using).toEqual(jasmine.any Acid.Validator)
      it 'is updating', ->
        using = validator.using
        expect(validator.verify('data').data()).toEqual using.data()

    describe '#data', ->
      validator = new Acid.Validator()
      it 'gets currently set data', -> expect(validator.data()).toBeNull()

    describe '#verify', ->
      validator = new Acid.Validator()
      it 'is chainable', -> expect(validator.verify()).toBe validator
      it 'sets data', -> expect(validator.verify('data').data()).toEqual 'data'

    describe '#rule', ->
      validator = new Acid.Validator rules
      it 'is chainable', -> expect(validator.rule()).toBe validator
      it 'executes a rule using Mixin', -> expect(-> validator.rule {invalidRule: 4}).toThrow()

    describe '#result', ->
      validator = new Acid.Validator rules
      it 'is not chainable', -> expect(validator.result).not.toBe validator
      it 'reflects the current rule chain status', ->
        expect(validator.verify('data').using.rule({length: 5}).rule({minLength: 1}).result()).toBe false
      it 'resets on subsequent calls', ->
        validator.verify('data').using.rule({length: 5}).result()
        expect(validator.result()).toBe true
