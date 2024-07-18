{ ... }:

{
  programs.nixvim = {
    plugins.illuminate = {
      enable = true;
      delay = 120;
      filetypesDenylist = [
        "dirvish"
        "fugitive"
        "alpha"
        "NvimTree"
        "lazy"
        "Trouble"
        "lir"
        "Outline"
        "spectre_panel"
        "toggleterm"
        "DressingSelect"
        "TelescopePrompt"
      ];
    };
  };
}
