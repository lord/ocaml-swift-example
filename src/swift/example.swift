import Cocoa

@_cdecl("add_one")
public func add_one(a: value) -> value {
  // it's critical to call Value(raw: _) on ALL arguments before you do anything
  // that could allocate on the ocaml heap
  let number = Value(raw: a).int()
  // make sure you raw .raw() as the very last thing you do when returning; you
  // should never hold on to the output of raw() while doing anything that could
  // allocate on the ocaml heap. within your Swift, use only Value, never value
  return Value(from: number + 1).raw()
}

class Foo {
  let num: Int
  init(num: Int) {
    self.num = num
  }
}

@_cdecl("wrap_foo")
public func wrap_foo() -> value {
  let foo = Foo(num: 12345)
  return Value(wrap: foo).raw()
}

@_cdecl("unwrap_foo")
public func unwrap_foo(a: value) -> value {
  let foo: Foo = Value(raw: a).unwrap()
  return Value(from: foo.num).raw()
}
