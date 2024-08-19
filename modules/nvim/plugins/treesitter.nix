{ ... }:

{
  plugins.treesitter = {
    enable = true;
    indent = true;
    ensureInstalled = [
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
}
