{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.packages.pkgs.java;
  isJDK = package:
    with lib;
    let
      pkg =
        if isDerivation package then
          package
        else if isStringLike package then
          pkgs."${package}" or { }
        else
          throw "Cannot check if ${package} is a JDK"
      ;
    in
    (pkg.meta.mainProgram or false) == "java"
  ;

  printJDKScript = pkgs.writeShellScriptBin "printjdks" ''
    javaHomeString=
    if [ -n "$JAVA_HOME" ]; then
      javaHomeString="\"$JAVA_HOME\" (according to \$JAVA_HOME)"
    else
      javaHomeString="No \$JAVA_HOME is set."
    fi
    cat <<EOF
    The currently configured JDK is located at

        "${cfg.jdk.package}" (according to configuration)
        $javaHomeString

    (if the two paths are different, make sure that 'programs.java.package' is set correctly)

    ${if cfg.jdk.extraPackages != [ ] then
      "The following extra JDKs are available:\n\n${lib.strings.concatLines (builtins.map (pkg: "  - ${pkg}") cfg.jdk.extraPackages)}"
      else "No extra JDKs are available."}
    EOF
  '';
in
{
  options = {
    tsrk.packages.pkgs.java = {
      enable = lib.options.mkEnableOption "tsrk's Java development bundle";

      jdk.package = lib.options.mkPackageOption pkgs "Java JDK" {
        default = [ "jdk" ];
        example = "pkgs.jdk11"; # Other JDKs like Azul Zulu also works.
        extraDescription = "Other JDKs like Azul Zulu might also work.";
      };

      jdk.extraPackages = lib.options.mkOption {
        default = [ ];
        example = [ pkgs.jdk11 ];
        type = lib.types.listOf lib.types.package;
        description = "Extra JDK packages to install";
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

    assertions = builtins.map
      (package: {
        assertion = isJDK package;
        message = "${package} is not a valid JDK pacakge.";
      })
      cfg.jdk.extraPackages;

    programs.java = {
      enable = true;
      package = lib.meta.hiPrio cfg.jdk.package;
    };

    environment.systemPackages =
      [ printJDKScript ]
      ++ cfg.jdk.extraPackages
      ++ (lib.lists.optional cfg.maven.enable pkgs.maven)
      ++ (lib.lists.optional cfg.gradle.enable cfg.gradle.package);
  };
}
