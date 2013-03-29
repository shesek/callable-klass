Allows to create constructor functions ("classes") that returns callable instances.

Example:

```coffee
callable = require 'callable-klass'

Foo = callable class
  a: -> 1
  b: -> 2
  callable: -> a() + b()

# the `callable` function returns a new constructor that delegates to the original one
# and adds some magic. Foo still works as expected - its `prototype` is set to the original
# prototype, and the function's properties are still accessible.

foo = new Foo

# `foo` also works as expected, foo.a() and foo.b() works, but you can also call
# foo() directly, which delegates to the `callable` method

foo() # same as foo.callable(), returns 3
```
