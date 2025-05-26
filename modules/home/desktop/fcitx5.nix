# Copyright (c) 2025 tsrk. <tsrk@tsrk.me>
# This file is licensed under the MIT license
# See the LICENSE file in the repository root for more info.

# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:

let
  cfg = config.tsrk.fcitx5;
  mkSectionList = list:
    let
      foldedAttr = lib.lists.foldl' (self: current: {
        _count = self._count + 1;
        final = self.final // { "${builtins.toString self._count}" = current; };
      }) {
        _count = 0;
        final = { };
      } list;
    in foldedAttr.final;

  inputGroupsModule = {
    options = {
      defaultLayout = lib.options.mkOption {
        type = lib.types.str;
        description = "Default layout of this group";
        example = "us";
      };

      defaultInputMethod = lib.options.mkOption {
        type = lib.types.str;
        description = "Default Input Method for this group";
        example = "keyboard-us";
      };

      items = lib.options.mkOption {
        type = lib.types.attrs;
        description = "Items of this group";
        default = { };
        example = lib.literalExpression ''
          {
            "keyboard-us" = "";
            "mozc" = "";
          }
        '';
      };
    };
  };
in {
  options = {
    tsrk.fcitx5 = {
      enable = lib.options.mkEnableOption "tsrk's Fcitx5 configuration";
      groups = lib.options.mkOption {
        type = with lib.types; lazyAttrsOf (submodule inputGroupsModule);
        description = "Input groups";
        default = { };
        example = lib.literalExpression ''
          {
            "US Only" = {
              defaultLayout = "us";
              defaultInputMethod = "keyboard-us";
              items = {
                "keyboard-us" = "";
              };
            };
            "French and Japanese" = {
              defaultLayout = "us_qwerty-fr";
              defaultInputMethod = "keyboard-us_qwerty-fr";
              items = {
                "keyboard-us_qwerty-fr" = "";
                "mozc" = "";
              };
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = lib.mkDefault true;
      type = lib.mkDefault "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
        settings = {
          globalOptions = {
            Behavior = {
              # Active By Default
              ActiveByDefault = false;
              # Reset state on Focus In
              resetStateWhenFocusIn = "No";
              # Share Input State
              ShareInputState = "No";
              # Show preedit in application
              PreeditEnabledByDefault = true;
              # Show Input Method Information when switch input method
              ShowInputMethodInformation = true;
              # Show Input Method Information when changing focus
              showInputMethodInformationWhenFocusIn = true;
              # Show compact input method information
              CompactInputMethodInformation = true;
              # Show first input method information
              ShowFirstInputMethodInformation = true;
              # Default page size
              DefaultPageSize = 5;
              # Override Xkb Option
              OverrideXkbOption = false;
              # Custom Xkb Option
              CustomXkbOption = "";
              # Force Enabled Addons
              EnabledAddons = "";
              # Force Disabled Addons
              DisabledAddons = "";
              # Preload input method to be used by default
              PreloadInputMethod = true;
              # Allow input method in the password field
              AllowInputMethodForPassword = false;
              # Show preedit text when typing password
              ShowPreeditForPassword = false;
              # Interval of saving user data in minutes
              AutoSavePeriod = 30;
            };

            Hotkey = {
              # Enumerate when press trigger key repeatedly
              EnumerateWithTriggerKeys = true;
              # Temporally switch between first and current Input Method
              AltTriggerKeys = "";
              # Enumerate Input Method Forward
              EnumerateForwardKeys = "";
              # Enumerate Input Method Backward
              EnumerateBackwardKeys = "";
              # Skip first input method while enumerating
              EnumerateSkipFirst = false;
            };

            "Hotkey/TriggerKeys" =
              mkSectionList [ "Control+space" "Zenkaku_Hankaku" "Hangul" ];

            "Hotkey/EnumerateGroupForwardKeys" =
              mkSectionList [ "Control+space" ];

            "Hotkey/EnumerateGroupBackwardKeys" =
              mkSectionList [ "Shift+Super+space" ];

            "Hotkey/ActivateKeys" = mkSectionList [ "Hangul_Hanja" ];
            "Hotkey/DeactivateKeys" = mkSectionList [ "Hangul_Romaja" ];
            "Hotkey/PrevPage" = mkSectionList [ "Up" ];
            "Hotkey/NextPage" = mkSectionList [ "Down" ];
            "Hotkey/PrevCandidate" = mkSectionList [ "Shift+Tab" ];
            "Hotkey/NextCandidate" = mkSectionList [ "Tab" ];
            "Hotkey/TogglePreedit" = mkSectionList [ "Control+Alt+P" ];
          };

          inputMethod = let
            mkGroupItems = index: items:
              let
                foldedAttr = lib.lists.foldl' (self: current: {
                  _count = self._count + 1;
                  final = self.final // {
                    "Groups/${builtins.toString index}/Items/${
                      builtins.toString self._count
                    }" = {
                      Name = current.name;
                      Layout = current.value;
                    };
                  };
                }) {
                  _count = 0;
                  final = { };
                } items;
              in foldedAttr.final;
            mkGroupList = items:
              let
                foldedAttr = lib.lists.foldl' (self: current: {
                  _count = self._count + 1;
                  final = self.final // {
                    "Groups/${builtins.toString self._count}" = {
                      Name = current.name;
                      "Default Layout" = current.value.defaultLayout;
                      DefaultIM = current.value.defaultInputMethod;
                    };
                  } // mkGroupItems self._count
                    (lib.attrsets.attrsToList current.value.items);
                }) {
                  _count = 0;
                  final = { };
                } items;
              in foldedAttr.final;
          in mkGroupList (lib.attrsets.attrsToList cfg.groups) // {
            GroupOrder = mkSectionList (builtins.attrNames cfg.groups);
          };

          addons = {
            clipboard = {
              globalSection = {
                PastePrimaryKey = "";
                "Number of entries" = 5;
                # Do not show password from password managers
                IgnorePasswordFromPasswordManager = false;
                # Hidden clipboard content that contains a password
                ShowPassword = true;
                # Seconds before clearing password
                ClearPasswordAfter = 30;
              };
              sections.TriggerKeys = mkSectionList [ "Control+semicolon" ];
            };
            notifications.globalSection.HiddenNotifications = "";
          };
        };
      };
    };
  };
}
