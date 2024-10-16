{ pkgSet, ... }:

let
  inherit (pkgSet) pkgs;
in
contents:
builtins.fromJSON (
  builtins.readFile (
    pkgs.runCommandLocal "yaml-${builtins.hashString "sha256" contents }-as.json"
    {
      nativeBuildInputs = [ pkgs.yj ];
    } ''
      yj <<EOF > "$out"
      ${contents}
      EOF
    ''
  )
)
