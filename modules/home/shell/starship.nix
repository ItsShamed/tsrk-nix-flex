{ config, lib, pkgs, ... }:

{
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  programs.starship.settings = {
    format = lib.concatStrings [
      "$username@$hostname: "
      "$directory"
      "$git_branch"
      "$git_state"
      "$git_metrics"
      "$git_status"
      "$c"
      "$cmake"
      "$python"
      "$nodejs"
      "$java"
      "$dotnet"
      "$ocaml"
      "$rust"
      "$php"
      "$line_break"
      "$jobs"
      "$os"
      "$nix_shell"
      "$shell"
      "$character"
    ];

    right_format = lib.concatStrings [
      "$time"
      "$status"
    ];

    directory.truncation_symbol = "…/";

    username = {
      show_always = true;
      format = "[$user]($style)";
    };

    hostname = {
      ssh_only = false;
      format = "[$ssh_symbol$hostname]($style)";
    };

    time.disabled = false;
    status.disabled = false;
    shell.disabled = false;
    os.disabled = false;
  };
}
