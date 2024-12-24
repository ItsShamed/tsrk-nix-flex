{ lib, ... }:

{
  plugins.markdown-preview = {
    enable = true;
    settings = {
      browser = lib.mkDefault (lib.warn
        "markdown-preview browser is set to 'librewolf', if it's not what you want, please change `plugins.markdown-preview.settings.browser`"
        "librewolf");
    };
  };
}
