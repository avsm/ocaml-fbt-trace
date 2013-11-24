let foo () =
  print_endline "one";
  print_endline "two";
  print_endline "three"

let bar () =
  print_endline "onex";
  print_endline "twox";
  print_endline "threex"

let () =
  foo ();
  bar ()
