class Value {
  let inner: boxroot
  init(raw: value) {
    inner = boxroot_create(raw)
  }
  init(raw_rooted: boxroot) {
    inner = raw_rooted
  }
  init(from: Int) {
    inner = boxroot_create(f_val_long(from))
  }
  init(from: Float64) {
    inner = boxroot_create(f_val_double(from))
  }
  init(from: Bool) {
    inner = boxroot_create(f_val_bool(from))
  }
  init(from: ()) {
    inner = boxroot_create(f_val_long(0))
  }
  init<T>(wrap: T) {
    let p = Unmanaged.passRetained(Box(wrap))
    inner = f_wrap_custom(p.toOpaque())!
  }
  deinit {
    boxroot_delete(inner)
  }

  // kind tests
  func is_long() -> Bool {
    return f_is_long(inner)
  }
  func is_block() -> Bool {
    return f_is_block(inner)
  }
  func is_none() -> Bool {
    return f_is_none(inner)
  }
  func is_some() -> Bool {
    return f_is_some(inner)
  }

  // operations on integers
  func int() -> Int {
    return f_long_val(inner)
  }
  func float() -> Float64 {
    return f_double_val(inner)
  }
  func raw() -> value {
    return boxroot_get(inner)
  }

  // accessing blocks
  func tag() -> Int {
    return f_tag_val(inner)
  }
  func field(_ i: Int) -> Value {
    return Value(raw_rooted: f_field(inner, i))
  }
  func field_float(_ i: Int) -> Float64 {
    return f_field_double(inner, i)
  }
  func store_field(_ i: Int, _ v: Value) {
    f_store_field(inner, i, v.inner)
  }
  func store_field_float(_ i: Int, _ v: Float64) {
    f_store_field_double(inner, i, v)
  }
  func string_length() -> Int {
    return f_string_length(inner)
  }
  func string_val() -> String {
    return String(cString: f_string_val(inner))
  }
  func double_val() -> Double {
    return f_double_val(inner)
  }

  // call ocaml functions
  func callback1(_ v: Value) -> Value {
    return Value(raw_rooted: f_callback1(inner, v.inner))
  }
  func callback2(_ v1: Value, _ v2: Value) -> Value {
    return Value(raw_rooted: f_callback2(inner, v1.inner, v2.inner))
  }
  func callback3(_ v1: Value, _ v2: Value, _ v3: Value) -> Value {
    return Value(raw_rooted: f_callback3(inner, v1.inner, v2.inner, v3.inner))
  }

  // allocate new ocaml values
  static func alloc(size: Int, tag: Int) -> Value {
    return Value(raw_rooted: f_caml_alloc(size, tag))
  }

  static func alloc_float_array(size: Int) -> Value {
    return Value(raw_rooted: f_caml_alloc_float_array(size))
  }

  func unwrap<T>() -> T {
    let p = f_unwrap_custom(inner)
    return Unmanaged<Box<T>>.fromOpaque(p!).takeUnretainedValue().value
  }
}

private final class Box<T> {
  let value: T

  init(_ value: T) {
    self.value = value
  }
}

@_cdecl("swift_bridge_destroy_capsule")
public func swift_bridge_destroy_capsule(p: UnsafeRawPointer) {
  Unmanaged<AnyObject>.fromOpaque(p).release()
}
