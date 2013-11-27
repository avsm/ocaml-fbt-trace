#!/bin/sh -e

rm -rf _build
ocamlbuild -use-ocamlfind -tag debug -pkgs ANSITerminal lib/fbt_trace.cma lib/fbt_trace.cmxs lib/fbt_trace.cmxa
ocamlbuild -use-ocamlfind -tag debug -syntax camlp4o -pkgs camlp4.extend,camlp4.quotations.o pa_lib/pa_fbt_trace.cma pa_lib/pa_fbt_trace.cmxs

case $1 in
install)
  ocamlfind remove fbt_trace || true
  ocamlfind $OCAMLFIND_FLAGS install fbt_trace META _build/pa_lib/* _build/lib/*
  ;;
test)
  rm -rf _build
  ocamlbuild -classic-display -tag debug -use-ocamlfind -pkg fbt_trace,fbt_trace.syntax -syntax camlp4o lib_test/test.native
  ./_build/lib_test/test.native
  FBT_TRACE_MINOR_GC=1 ./_build/lib_test/test.native
  FBT_TRACE_COMPACT_GC=1 ./_build/lib_test/test.native
  FBT_TRACE_SHOW_BACKTRACE=1 ./_build/lib_test/test.native
  ;;
*) ;;
esac
