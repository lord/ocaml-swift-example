open! Core

external add_one : int -> int = "add_one"

let%expect_test "add_one" =
  let n = add_one 1 in
  print_s [%message (n : int)];
  [%expect {| (n 2) |}]
;;

type foo

external wrap_foo : unit -> foo = "wrap_foo"
external unwrap_foo : foo -> int = "unwrap_foo"

let%expect_test "values opaque to ocaml" =
  let opaque = wrap_foo () in
  let n = unwrap_foo opaque in
  print_s [%message (n : int)];
  [%expect {| (n 12345) |}]
;;
