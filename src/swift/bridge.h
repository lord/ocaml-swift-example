#ifndef bridge_h
#define bridge_h

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include <caml/custom.h>
#include <caml/intext.h>
#include <caml/threads.h>
#include "../../boxroot/boxroot.h"

value f_val_long(long);
value f_val_bool(bool);
value f_val_double(double);
long f_long_val(boxroot);
bool f_is_long(boxroot);
bool f_is_block(boxroot);
bool f_is_none(boxroot);
bool f_is_some(boxroot);
long f_tag_val(boxroot);
boxroot f_field(boxroot, long);
double f_field_double(boxroot, long);
void f_store_field(boxroot, long, boxroot);
void f_store_field_double(boxroot, long, double);
long f_string_length(boxroot);
const char* f_string_val(boxroot);
double f_double_val(boxroot);
boxroot f_callback1(boxroot, boxroot);
boxroot f_callback2(boxroot, boxroot, boxroot);
boxroot f_callback3(boxroot, boxroot, boxroot, boxroot);
boxroot f_wrap_custom(void* data);
void* f_unwrap_custom(boxroot v);
boxroot f_caml_alloc(long n, long t);
boxroot f_caml_alloc_float_array(long n);


#endif /* bridge_h */
