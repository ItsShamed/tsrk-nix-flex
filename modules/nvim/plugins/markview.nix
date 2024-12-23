{ ... }:

{
  plugins.markview = {
    enable = true;
    luaConfig.pre = ''
      local presets = require("markview.presets");
    '';
    settings = {
      hybrid_modes = [ "n" ];
      checkboxes = { __raw = "presets.checkboxes.nerd"; };
      headings = {
        setext_1 = {
          style = "decorated";
        };
        setext_2 = {
          style = "decorated";
        };
      };
      html = {
        enable = true;
        tags = {
          enable = true;
        };
      };
      inline_codes.enable = true;
      links = {
        enable = true;
        hyperlinks.enable = true;
        images.enable = true;
        emails.enable = true;
        internal_links.enable = true;
      };
    };
  };
}
