#!/bin/sh -e

rm -rf _build
ocamlbuild -use-ocamlfind -pkgs ANSITerminal lib/fbt_trace.cma lib/fbt_trace.cmxs lib/fbt_trace.cmxa
ocamlbuild -use-ocamlfind -syntax camlp4o -pkgs camlp4.extend,camlp4.quotations.o pa_lib/pa_fbt_trace.cma pa_lib/pa_fbt_trace.cmxs
ocamlfind remove fbt_trace || true
ocamlfind install fbt_trace META _build/pa_lib/* _build/lib/*
rm -rf _build
ocamlbuild -classic-display -tag verbose -use-ocamlfind -pkg fbt_trace,fbt_trace.syntax -syntax camlp4o lib_test/test.native
./_build/lib_test/test.native