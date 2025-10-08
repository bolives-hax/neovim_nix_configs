{ config, lib, ... }:
{
  # plugin that gives some insight into what neovim
  # (specifically lsp in our case) is doing in the bottom
  # right corner. E.g if nixd evaluates stuff or rust-analyzer
  plugins.fidget = {
    enable = true;
  };
  plugins.lsp = {
    enable = true;
  };

  plugins.cmp.settings.sources = lib.optional config.plugins.cmp.enable {
    name = "nvim_lsp";
  };

  imports = [
    ./nixd.nix
  ];
}
