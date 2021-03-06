#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let () =
  let install = false in
  let metas = [
    Pkg.meta_file ~install "pkg/META.unix";
    Pkg.meta_file ~install "pkg/META.freestanding" ]
  in
  let lint_deps_excluding = Some ["mirage-types-lwt"] in
  let opams = [
    Pkg.opam_file ~install ~lint_deps_excluding "mirage-clock-unix.opam";
    Pkg.opam_file ~install ~lint_deps_excluding "mirage-clock-freestanding.opam" ]
  in
  Pkg.describe ~metas ~opams "mirage-clock-unix" @@ fun c ->
  match Conf.pkg_name c with
  | "mirage-clock-unix" ->
      Ok [  Pkg.lib "pkg/META.unix" ~dst:"META";
            Pkg.mllib "unix/mirage-clock-unix.mllib";
            Pkg.clib "unix/libmirage-clock-unix_stubs.clib";
            Pkg.test "lib_test/portable"]
  | "mirage-clock-freestanding" ->
      Ok [  Pkg.lib "pkg/META.freestanding" ~dst:"META";
            Pkg.mllib "freestanding/mirage-clock-freestanding.mllib" ]
  | other ->
      R.error_msgf "unknown package name: %s" other
