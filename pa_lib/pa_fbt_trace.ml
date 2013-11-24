(*
 * Copyright (c) 2008, Jeremie Dimino <jeremie@dimino.org>
 * Copyright (c) 2012-2013, Anil Madhavapeddy <anil@recoil.org>
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the <organization> nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * 
 *)

open Camlp4.PreCast

let add_debug_expr name e =
  let _loc = Ast.loc_of_expr e in
  <:expr< Fbt_trace.print
          $str:Loc.file_name _loc$
          $str:name$;
          $e$ >>

let rec map_match_case name = function
  | <:match_case@_loc< $m1$ | $m2$ >> ->
      <:match_case< $map_match_case name m1$ | $map_match_case name m2$ >>
  | <:match_case@_loc< $p$ when $w$ -> $e$ >> ->
      <:match_case< $p$ when $w$ -> $add_debug_expr name e$ >>
  | m -> m

let rec map_expr name = function
  | <:expr@_loc< fun $p$ -> $e$ >> ->
      <:expr< fun $p$ -> $map_expr name e$ >>
  | <:expr@_loc< function $m$ >> ->
      <:expr< function $map_match_case name m$ >>
  | e ->
      add_debug_expr name e

let rec map_binding = function
  | <:binding@_loc< $lid:func$ = fun $p$ -> $e$ >> ->
      <:binding< $lid:func$ = fun $p$ -> $map_expr func e$ >>
  | <:binding@_loc< $lid:func$ = function $m$ >> ->
      <:binding< $lid:func$ = function $map_match_case func m$ >>
  | <:binding@_loc< $a$ and $b$ >> ->
      <:binding< $map_binding a$ and $map_binding b$ >>
  | x -> x

let map_str_item = function
  | Ast.StVal (_loc, rec_mode, binding) ->
      <:str_item< let $rec:rec_mode$ $map_binding binding$ >>
  | x -> x

let () = AstFilters.register_str_item_filter (Ast.map_str_item map_str_item)#str_item
