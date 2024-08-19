{ ... }:

{
  plugins.no-neck-pain = {
    enable = true;
    settings = {
      width = 150;
      autocmds = {
        enableOnVimEnter = true;
        enableOnTabEnter = true;
        skipEnteringNoNeckPainBuffer = true;
      };

      buffers = {
        right.enabled = false;
      };

      mappings = {
        enabled = true;
      };
    };
  };
}
