{ config, pkgs, lib, ... }:

let cfg = config.tsrk.packages.pkgs.cpp;
in {
  options = {
    tsrk.packages.pkgs.cpp = {
      enable = lib.options.mkEnableOption "tsrk's C++ development bundle";
      ide = {
        enable = (lib.options.mkEnableOption "the C++ IDE") // {
          default = true;
        };
        package = lib.options.mkPackageOption pkgs.jetbrains "C++ IDE" {
          default = [ "clion" ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ httplib libyamlcpp ]
      ++ (lib.lists.optional cfg.ide.enable cfg.ide.package);
  };
}
