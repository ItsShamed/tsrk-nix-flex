{ lib, helpers, ... }:

with helpers;
let
  valuedMappingType = {
    freeformType = lib.types.attrsOf lib.types.anything;
    options = {
      mapping = lib.options.mkOption {
        type = lib.types.str;
        description = "The global mapping.";
        default = "";
      };
      value = lib.options.mkOption {
        type = lib.types.ints.positive;
        description = "The amount of width to change.";
        default = 5;
      };
    };
  };

  mkStaticMapping = pluginDefault: actionDescription: helpers.defaultNullOpts.mkNullableWithRaw' {
    type = lib.types.either lib.types.str lib.types.bool;
    inherit pluginDefault;
    description = ''
      Sets a global mapping to Neovim, which allows you to ${actionDescription}.
      When `false`, the mapping is not created.
    '';
  };

  mkValuedMapping = pluginDefault: actionDescription: helpers.defaultNullOpts.mkNullableWithRaw' {
    type = lib.types.either (lib.types.either (lib.types.submodule valuedMappingType) lib.types.str) lib.types.bool;
    inherit pluginDefault;
    description = ''
      Sets a global mapping to Neovim, which allows you to ${actionDescription}.
      When `false`, the mapping is not created.
    '';
  };
in

helpers.neovim-plugin.mkNeovimPlugin {
  name = "no-neck-pain";
  originalName = "no-neck-pain.nvim";
  package = "no-neck-pain-nvim";

  maintainers = [ ];

  settingsOptions = with defaultNullOpts; {
    debug = mkBool false ''
      Prints useful logs about triggered events, and reasons actions are executed.
    '';

    width = mkPositiveInt 100 ''
      The width of the focused window that will be centered.
      When the terminal width is less than the `width` option, the side buffers won't be created.
    '';

    minSideBufferWidth = mkPositiveInt 10 ''
      Represents the lowest width value a side buffer should be.
      This option can be useful when switching window size frequently, example:
      in full screen screen, width is 210, you define an NNP `width` of 100, which creates each side buffer with a width of 50.
      If you resize your terminal to the half of the screen, each side buffer would be of width 5 and thereforce might not be useful and/or add "noise" to your workflow.
    '';

    disableOnLastBuffer = mkBool false ''
      Disables the plugin if the last valid buffer in the list have been closed.
    '';

    killAllBuffersOnDisable = mkBool false ''
      When `true`, disabling the plugin closes every other windows except the initially focused one.
    '';

    autocmds = mkSettingsOption {
      options = {
        enableOnVimEnter = mkBool false ''
          When `true`, enables the plugin when you start Neovim.
          If the main window is a side tree (e.g. NvimTree) or a dashboard, the command is delayed until it finds a valid window.
          The command is cleaned once it has successfuly ran once.
        '';

        enableOnTabEnter = mkBool false ''
          When `true`, enables the plugin when you enter a new Tab.
          note: it does not trigger if you come back to an existing tab, to prevent unwanted interfer with user's decisions.
        '';
        reloadOnColorSchemeChange = mkBool false ''
          When `true`, reloads the plugin configuration after a colorscheme change.
        '';

        skipEnteringNoNeckPainBuffer = mkBool false ''
          When `true`, entering one of no-neck-pain side buffer will automatically skip it and go to the next available buffer.
        '';
      };
      description = "Adds autocmd (@see `:h autocmd`) which aims at automatically enabling the plugin.";
      example = {
        enableOnVimEnter = true;
        reloadOnColorSchemeChange = true;
        skipEnteringNoNeckPainBuffer = true;
      };
    };

    mappings = mkSettingsOption {
      options = {
        enabled = mkBool false ''
          When `true`, creates all the mappings that are not set to `false`.
        '';

        toggle = mkStaticMapping "<Leader>np" "toggle the plugin";
        toggleLeftSide = mkStaticMapping "<Leader>nql" "toggle the left side buffer";
        toggleRightSide = mkStaticMapping "<Leader>nql" "toggle the right side buffer";
        widthUp = mkValuedMapping "<Leader>n=" "increase the width of the main window";
        widthDown = mkValuedMapping "<Leader>n-" "decrease the width of the main window";
        scratchPad = mkStaticMapping "<Leader>ns" "toggle the scratchPad feature";
      };
      description = "Creates mappings for you to easily interact with the exposed commands.";
      example = {
        enabled = true;
      };
    };

    buffer =
      let
        mkNormalizedInt' = args: mkNullableWithRaw' (args // { type = (lib.types.ints.between (-1) 1); });
        mkNormalizedInt = pluginDefault: description: mkNormalizedInt' { inherit pluginDefault description; };
        scratchPad = mkSettingsOption {
          options = {
            enabled = mkBool false ''
              When `true`, automatically sets the following options to the side buffers:
              - `autowriteall`
              - `autoread`.
            '';

            pathToFile = mkStr "" ''
              The path to the file to save the scratchPad content to and load it in the buffer.
            '';
          };
          description = ''
            Leverages the side buffers as notepads, which work like any Neovim buffer and automatically saves its content at the given `location`.
            note: quitting an unsaved scratchPad buffer is non-blocking, and the content is still saved.
          '';
        };

        colors = mkSettingsOption {
          options = {
            background = mkStr null ''
              Hexadecimal color code to override the current background color of the buffer. (e.g. #24273A)
              Transparent backgrounds are supported by default.
              popular theme are supported by their name:
              - catppuccin-frappe
              - catppuccin-frappe-dark
              - catppuccin-latte
              - catppuccin-latte-dark
              - catppuccin-macchiato
              - catppuccin-macchiato-dark
              - catppuccin-mocha
              - catppuccin-mocha-dark
              - github-nvim-theme-dark
              - github-nvim-theme-dimmed
              - github-nvim-theme-light
              - rose-pine
              - rose-pine-dawn
              - rose-pine-moon
              - tokyonight-day
              - tokyonight-moon
              - tokyonight-night
              - tokyonight-storm
            '';

            blend = mkNormalizedInt 0 ''
              Brighten (positive) or darken (negative) the side buffers background color.
            '';

            text = mkStr null ''
              Hexadecimal color code to override the current text color of the buffer.
            '';
          };
          description = "NoNeckPain's buffer color options.";
          example = {
            background = "#24273A";
            text = "#7480c2";
          };
        };

        bufferScopedOptions = mkAttributeSet
          {
            filetype = "no-neck-pain";
            buftype = "nofile";
            bufhidden = "hide";
            buflisted = false;
            swapfile = false;
          } "Vim buffer-scoped options: any `vim.bo` options is accepted here.";

        windowScopedOptions = mkAttributeSet
          {
            cursorline = false;
            cursorcolumn = false;
            colorcolumn = 0;
            number = false;
            relativenumber = false;
            foldenable = false;
            list = false;
            wrap = false;
            linebreak = false;
          } "Vim window-scoped options: any `vim.wo` options is accepted here.";

        bufferOptions = mkSettingsOption {
          options = {
            enabled = mkBool true ''
              When `false`, the buffer won't be created.
            '';

            inherit colors scratchPad;

            bo = bufferScopedOptions;
            wo = windowScopedOptions;
          };
          description = "Side buffer option.";
        };
      in
      mkSettingsOption {
        options = {
          setNames = mkBool false ''
            When `true`, the side buffers will be named `no-neck-pain-left` and `no-neck-pain-right` respectively.
          '';

          inherit colors scratchPad;

          bo = bufferScopedOptions;
          wo = windowScopedOptions;

          left = bufferOptions;
          right = bufferOptions;
        };
        description = "Common options that are set to both side buffers.";
      };

    integrations =
      let
        mkTreeOption = name: { position ? "left", reopen ? true }: mkSettingsOption {
          options = {
            position = mkEnum [ "left" "right" ] position "The position of the tree.";
            reopen = mkBool reopen ''
              When `true`, if the tree was opened before enabling the plugin, we will reopen it.
            '';
          };
          description = ''
            By default, if ${name} is open, we will close it and reopen it when enabling the plugin,
            this prevents having the side buffers wrongly positioned.
          '';
        };

        leftTrees = lib.attrsets.genAttrs [
          "NvimTree"
          "NeoTree"
          "undotree"
        ]
          (name: mkTreeOption name { });


        rightTrees = lib.attrsets.genAttrs [
          "neotest"
          "TSPlayground"
          "outline"
        ]
          (name: mkTreeOption name { position = "right"; });
      in
      mkSettingsOption {
        options = (leftTrees // rightTrees // {
          # lmaoo NvimDAPUI is just built different
          NvimDAPUI = {
            position = mkEnum [ "none" ] "none" "The position of the tree.";
            reopen = mkBool true ''
              When `true`, if the tree was opened before enabling the plugin, we will reopen it.
            '';
          };
        });
        description = "Supported integrations that might clash with `no-neck-pain.nvim`'s behavior.";
      };
  };
}
