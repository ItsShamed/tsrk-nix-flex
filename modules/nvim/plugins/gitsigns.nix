{ ... }:

let icons = import ../utils/icons.nix;
in {
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame_formatter =
        "<author>, <author_time:%Y-%m-%d> - <summary>";
      preview_config = {
        border = "rounded";
        col = 1;
        relative = "cursor";
        row = 0;
        style = "minimal";
      };
      signs = {
        add.text = icons.ui.BoldLineLeft;
        change.text = icons.ui.BoldLineLeft;
        changedelete.text = icons.ui.BoldLineLeft;
        delete.text = icons.ui.Triangle;
        topdelete.text = icons.ui.Triangle;
      };
      update_debounce = 200;
    };
  };
}
