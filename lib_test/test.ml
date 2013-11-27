let foo () =
  print_endline "one";
  print_endline "two";
  print_endline "three"

let bar () =
  print_endline "onex";
  for i = 0 to 100 do ignore(String.create 16384); done;
  print_endline "twox";
  print_endline "threex";
  foo ()

let () =
  foo ();
  bar ();
  Moda.foo ();
  Moda.bar ()
