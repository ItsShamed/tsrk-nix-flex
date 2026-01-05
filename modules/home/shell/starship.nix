# Copyright (c) 2026 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT License.
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, ... }:

let
  cfg = config.tsrk.shell.starship;

  nerdFontsConfig = builtins.fromTOML (
    builtins.readFile ./files/nerd-font-symbols.toml
  );

  includeIcons = [
    "directory"
    "hostname"
    "os"
    "nix_shell"
  ];

  filteredNfConfig = (
    lib.attrsets.filterAttrs (
      n: _: (builtins.elem n includeIcons) || (builtins.elem n cfg.envPrompts)
    ) nerdFontsConfig
  );

  envConfigs = (
    lib.attrsets.genAttrs cfg.envPrompts (_: {
      style = "bg:#212736";
      format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
    })
  );

  iconConfig = (lib.attrsets.recursiveUpdate envConfigs filteredNfConfig);
in
{
  options = {
    tsrk.shell.starship = {
      enable = lib.options.mkEnableOption "tsrk's Starship prompt";
      envPrompts = lib.options.mkOption {
        description = "List of environment based prompts to show";
        type = lib.types.listOf lib.types.str;
        default = [
          "c"
          "cmake"
          "dart"
          "python"
          "nodejs"
          "java"
          "golang"
          "dotnet"
          "ocaml"
          "rust"
          "php"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship.enable = true;
    programs.starship.enableZshIntegration = true;
    programs.starship.enableBashIntegration = true;

    programs.starship.settings = (
      lib.attrsets.recursiveUpdate iconConfig {
        format = lib.concatStrings (
          [
            "[ $username@$hostname ](bg:#a3aed2 fg:#090c0c)"
            "[](bg:#769ff0 fg:#a3aed2)"
            "$directory"
            "[](fg:#769ff0 bg:#394260)"
            "$git_branch"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "[](fg:#394260 bg:#212736)"
          ]
          ++ (builtins.map (n: "$" + n) cfg.envPrompts)
          ++ [
            "[](fg:#212736 bg:#1d2230)"
            "$time"
            "[ ](fg:#1d2230)"
            "$line_break"
            "$jobs"
            "$os "
            "$nix_shell"
            "$kubernetes"
            "$shell"
            "$character"
          ]
        );

        right_format = lib.concatStrings [
          "$status"
          "$cmd_duration"
        ];

        directory = {
          style = "fg:#e3e5e5 bg:#769ff0";
          format = "[ $path ]($style)";
          truncation_symbol = "…/";
          fish_style_pwd_dir_length = 1;
          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = " ";
            Pictures = " ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
        };

        git_metrics = {
          added_style = "fg:#449dab bg:#394260";
          deleted_style = "fg:#914c54 bg:#394260";
        };

        git_status = {
          style = "bg:#394260";
          format = "[[($all_status $ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        };

        username = {
          style_user = "bold bg:#a3aed2 fg:#090c0c";
          style_root = "bold bg:#a3aed2 fg:#f52a65";
          show_always = true;
          format = "[$user]($style)";
        };

        hostname = {
          style = "bg:#a3aed2 fg:#090c0c";
          ssh_symbol = "  ";
          ssh_only = false;
          format = "[$hostname$ssh_symbol]($style)";
        };

        status = {
          symbol = " ";
          not_executable_symbol = " ";
          not_found_symbol = " ";
          sigint_symbol = " ";
          signal_symbol = " ";
          map_symbol = true;
          pipestatus = true;
          format = "[$symbol$status ($common_meaning$signal_name)]($style) ";
        };

        time = {
          disabled = false;
          style = "bg:#1d2230";
          format = "[[   $time ](fg:#a0a9cb bg:#1d2230)]($style)";
        };

        nix_shell = {
          symbol = "";
          impure_msg = "i";
          pure_msg = "p";
        };

        cmd_duration = {
          format = "in [$duration]($style)";
          show_notifications = true;
        };

        kubernetes = {
          disabled = false;
          symbol = "󱃾  ";
          format = "[$symbol$context( \\($namespace\\))]($style) ";
          detect_env_vars = [ "KUBECONFIG" ];
        };

        status.disabled = false;
        shell.disabled = false;
        os.disabled = false;
      }
    );
  };
}
