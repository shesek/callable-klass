callable = require '../callable.coffee'
{ deepEqual: deepEq, equal: eq } = assert = require 'assert'

describe 'callable', ->
  it 'Decorates constructor functions, and returns a function', ->
    ctor = callable ->
    assert typeof ctor is 'function'

  it 'Uses the original constructor prototype', ->
    ctor = callable orig_ctor = class then foo: 'bar'
    eq ctor.prototype, orig_ctor.prototype

  it 'Inhertis the original constructor properties', ->
    ctor = callable orig_ctor = class then @foo: 'bar'
    eq ctor.foo, 'bar'
    orig_ctor.baz = 'qux'
    eq ctor.baz, 'qux'

  it 'Returns callable instances', ->
    obj = new (callable ->)
    eq typeof obj, 'function'
    assert obj.call?
    assert obj.apply?

  it 'Delegates calls to the "callable" method, with the arguments and the this context', ->
    obj = new (callable class then callable: (a...) -> [this, a...])
    deepEq (obj 'a', 'b'), [obj, 'a', 'b']

  it 'Works with call() and apply()', ->
    obj = new (callable class then callable: (a...) -> [this, a...])
    ctx = {}
    deepEq (obj.call ctx, 'a', 'b'), [ctx, 'a', 'b']
    deepEq (obj.apply ctx, ['a', 'b']), [ctx, 'a', 'b']

  it 'Allows the constructor to return a different object', ->
    ctor = callable -> foo: 'bar'
    eq (new ctor).foo, 'bar'

  it 'Ignores non-objects return values from the constructor', ->
    ctor = callable class then constrctor: -> 'bar'
    eq (typeof new ctor), 'function'

  it 'passes constructor arguments', ->
    ctor = callable class
      constructor: (@a, @b) ->
      callable: -> @a + @b
    obj = new ctor 5, 6
    eq obj(), 11
