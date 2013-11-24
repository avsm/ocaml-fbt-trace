(*
 * Copyright (c) 2013, Anil Madhavapeddy <anil@recoil.org>
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

open ANSITerminal

let mod_colors = [| Red ; Green ; Yellow ; Blue ; Magenta ; Cyan |] 
let mod_pos = ref 0
let mod_mappings = Hashtbl.create 1

let new_color () =
  mod_pos := (!mod_pos + 1) mod (Array.length mod_colors);
  mod_colors.(!mod_pos)

let color_for_loc fname =
  try
    Hashtbl.find mod_mappings fname
  with
    Not_found ->
      let c = new_color () in
      Hashtbl.add mod_mappings fname c;
      c

let print fname msg =
  let fcol = color_for_loc fname in
  printf [Foreground fcol] ">>> %s: %s\n%!" fname msg;
  flush stdout
