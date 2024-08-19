{ ... }:

{
  plugins.comment = {
    enable = true;
    settings = {
      ignore = "^s";
      padding = true;
      sticky = true;
      mappings.basic = true;
      mappings.extra = true;
    };
  };
}
