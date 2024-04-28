{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openjdk17
    jetbrains.idea-ultimate
    jetbrains.webstorm
    dotnet-sdk_8
    mono
    jetbrains.rider
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "true";
  };
}
