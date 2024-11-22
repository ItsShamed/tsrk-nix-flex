{ ... }:

{
  plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      ensure_installed = [
        "bash"
        "c"
        "javascript"
        "json"
        "lua"
        "python"
        "typescript"
        "tsx"
        "css"
        "rust"
        "java"
        "yaml"
        "csharp"
      ];
    };
  };
}
