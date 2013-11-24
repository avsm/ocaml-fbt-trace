This Camlp4 extension introduces simple function boundary tracing to an OCaml
program.  Every toplevel function is rewritten to print a line whenever it is
called, allowing you to trace through all the functions being called.

This is only intended for debug use and not for production servers, since the
volume of data produced is really quite high.
