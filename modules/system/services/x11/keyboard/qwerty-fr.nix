{ config, lib, ... }:

let
  qwerty-fr = builtins.fetchGit {
    url = "https://github.com/qwerty-fr/qwerty-fr.git";
    rev = "3ac6e889a46e0c0aad44df2a0d23b3d8fe1257d5";
    ref = "refs/tags/v0.7.2";
  };
in {
  options = {
    tsrk.qwerty-fr = {
      enable = lib.options.mkEnableOption "the French QWERTY keyboard layout";
    };
  };

  config = lib.mkIf config.tsrk.qwerty-fr.enable {
    services.xserver.xkb.extraLayouts.us_qwerty-fr = {
      description =
        "QWERTY-based layout. Type EU languages, greek, math, currencies, and more!";
      languages = [ "eng" "fra" "deu" "spa" "grc" ];
      symbolsFile = "${qwerty-fr}/linux/us_qwerty-fr";
    };

    services.xserver.xkb.layout = "us_qwerty-fr";
  };
}
