open Ocamlbuild_plugin
open Command

let os = Ocamlbuild_pack.My_unix.run_and_read "uname -s"

let system_support_lib = match os with
| "Linux\n" -> [A "-cclib"; A "-lrt"]
| _ -> []

let () =
  dispatch begin function
  | After_rules ->
      flag ["mirage_clock_unix_ccopt"; "compile"]
        (S [A "-ccopt"; A "-O2"; A "-ccopt"; A "-g"; A "-ccopt"; A "-Wall"]);
      flag ["link"; "library"; "ocaml"; "native"; "use_mirage-clock-unix"]
        (S ([A "-cclib"; A "-lmirage-clock-unix_stubs"] @ system_support_lib));
      flag ["link"; "library"; "ocaml"; "byte"; "use_mirage-clock-unix"]
        (S ([A "-dllib"; A "-lmirage-clock-unix_stubs"] @ system_support_lib));
      flag ["link"; "ocaml"; "link_mirage-clock-unix"]
        (S ([A "unix/libmirage-clock-unix_stubs.a"] @ system_support_lib));
      dep ["link"; "ocaml"; "use_mirage-clock-unix"]
        ["unix/libmirage-clock-unix_stubs.a"];
  | _ -> ()
  end
