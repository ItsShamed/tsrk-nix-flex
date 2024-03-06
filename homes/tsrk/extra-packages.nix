{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openjdk17
    jetbrains.idea-ultimate
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
  };
}
