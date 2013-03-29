"use strict"

throw new Error 'This library relies on __proto__' unless (__proto__: a: 'b').a is 'b'

callable = (ctor) ->
  callable_ctor = ->
    obj = -> obj.callable.apply (this ? obj), arguments
    obj.__proto__ = ctor::
    result = ctor.apply obj, arguments
    if result is Object result then result
    else obj
  callable_ctor.__proto__ = ctor
  callable_ctor:: = ctor::
  # Copy call() and apply() from Function.prototype to the constructor prototype
  {call: callable_ctor::call, apply: callable_ctor::apply} = Function::
  callable_ctor

module.exports = callable

