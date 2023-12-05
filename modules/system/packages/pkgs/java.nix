{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.java;
in
{
  options = {
    tsrk.packages.pkgs.java = {
      enable = lib.options.mkEnableOption "tsrk's Java development bundle";

      ide = {
        enable = (lib.options.mkEnableOption "the Java IDE.") // { default = true; };
        package = lib.options.mkPackageOption pkgs.jetbrains "Java IDE" {
          default = [ "idea-ultimate" ];
          example = "pkgs.jetbrains.idea-community"; # hint: you also have pkgs.eclipses.eclipse-java for those insane enough to use that
        };
      };

      jdk.package = lib.options.mkPackageOption pkgs "Java JDK" {
        default = [ "jdk" ];
        example = "pkgs.jdk11"; # Other JDKs like Azul Zulu also works.
        extraDescription = "Other JDKs like Azul Zulu might also work.";
      };

      maven.enable = (lib.options.mkEnableOption "Maven") // { default = true; };

      gradle = {
        enable = lib.options.mkEnableOption "Gradle";
        package = lib.options.mkPackageOption pkgs "Gradle" {
          default = [ "gradle" ];
          example = "pkgs.gradle_7";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = cfg.jdk.package;
    };

    environment.systemPackages =
      [ ]
      ++ (lib.lists.optional cfg.ide.enable cfg.ide.package)
      ++ (lib.lists.optional cfg.maven.enable pkgs.maven)
      ++ (lib.lists.optional cfg.gradle.enable cfg.gradle.package);
  };
}
