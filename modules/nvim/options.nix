{ ... }:

{
  opts = {
    backup = false;
    cmdheight = 1;
    colorcolumn = "80";
    completeopt = [ "menuone" "noselect" ];
    conceallevel = 0;
    fileencoding = "utf-8";
    foldmethod = "manual";
    hidden = true;
    hlsearch = true;
    ignorecase = true;
    relativenumber = true;
    mouse = "a";
    pumheight = 10;
    showmode = false;
    showtabline = 0;
    smartcase = true;
    smartindent = true;
    splitbelow = true;
    splitright = true;
    swapfile = false;
    termguicolors = true;
    timeoutlen = 1000;
    title = true;
    undofile = true;
    updatetime = 100;
    writebackup = false;
    expandtab = true;
    shiftwidth = 4;
    tabstop = 4;
    softtabstop = 4;
    cursorline = true;
    number = true;
    laststatus = 3;
    showcmd = false;
    ruler = false;
    numberwidth = 4;
    signcolumn = "yes";
    wrap = false;
    scrolloff = 8;
    sidescrolloff = 8;
    fillchars.eob = " ";
    linebreak = true;
  };

  extraConfigLuaPre = ''
    vim.opt.shortmess:append "c"
    vim.opt.whichwrap:append "<,>,[,],h,l"
    vim.opt.iskeyword:append "-"
    vim.opt.formatoptions:remove { "c", "r", "o" }
  '';
}
