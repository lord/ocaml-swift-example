#include "bridge.h"


void swift_bridge_destroy_capsule(void* capsule);

value f_val_long(long a) {
    CAMLparam0();
    CAMLlocal1(v);
    v = Val_long(a);
    CAMLreturn(v);
}

value f_val_double(double a) {
    CAMLparam0();
    CAMLlocal1(v);
    v = caml_copy_double(a);
    CAMLreturn(v);
}

value f_val_bool(bool a) {
    CAMLparam0();
    CAMLlocal1(v);
    v = Val_bool(a);
    CAMLreturn(v);
}

long f_long_val(boxroot a) {
    return Long_val(boxroot_get(a));
}

bool f_is_long(boxroot v) {
    return Is_long(boxroot_get(v));
}

bool f_is_block(boxroot v) {
    return Is_block(boxroot_get(v));
}

bool f_is_none(boxroot v) {
    return Is_none(boxroot_get(v));
}

bool f_is_some(boxroot v) {
    return Is_some(boxroot_get(v));
}

long f_tag_val(boxroot v) {
    return Tag_val(boxroot_get(v));
}

double f_field_double(boxroot v, long a) {
    return Double_flat_field(boxroot_get(v), a);
}
void f_store_field_double(boxroot v, long a, double data) {
    Store_double_flat_field(boxroot_get(v), a, data);
}
boxroot f_field(boxroot v, long a) {
    return boxroot_create(Field(boxroot_get(v), a));
}
void f_store_field(boxroot v , long a, boxroot data) {
    Store_field(boxroot_get(v), a, boxroot_get(data));
}
long f_string_length(boxroot v) {
    return caml_string_length(boxroot_get(v));
}
const char* f_string_val(boxroot v) {
    return String_val(boxroot_get(v));
}
double f_double_val(boxroot v) {
    return Double_val(boxroot_get(v));
}
boxroot f_callback1(boxroot f, boxroot a) {
    return boxroot_create(caml_callback(boxroot_get(f), boxroot_get(a)));
}
boxroot f_callback2(boxroot f, boxroot a, boxroot b) {
    return boxroot_create(caml_callback2(boxroot_get(f), boxroot_get(a), boxroot_get(b)));
}
boxroot f_callback3(boxroot f, boxroot a, boxroot b, boxroot c) {
    return boxroot_create(caml_callback3(boxroot_get(f), boxroot_get(a), boxroot_get(b), boxroot_get(c)));
}

void capsule_finalize(value v) {
    void** p = Data_custom_val(v);
    swift_bridge_destroy_capsule(*p);
}

struct custom_operations swift_capsule_ops = {
    "swift.custom",
    custom_finalize_default,
    custom_compare_default,
    custom_compare_ext_default,
    custom_hash_default,
    custom_serialize_default,
};

boxroot f_wrap_custom(void* data) {
    value custom = caml_alloc_custom(&swift_capsule_ops, sizeof(void*), 0, 1);
    void** p = Data_custom_val(custom);
    *p = data;
    return boxroot_create(custom);
}

void* f_unwrap_custom(boxroot v) {
    void** p = Data_custom_val(boxroot_get(v));
    return *p;
}

boxroot f_caml_alloc_float_array(long n) {
    return boxroot_create(caml_alloc_float_array(n));
}

boxroot f_caml_alloc(long n, long t) {
    return boxroot_create(caml_alloc(n, t));
}