{ config, lib, ... }:
{
  plugins = {
    # completions for vimtex
    cmp-vimtex = {
      enable = true;
    };
    # vimtex (provides lotsa helpers to work with LaTeX)
    vimtex = {
      enable = true;
      settings = {
        view_method = "zathura";
      };
    };
  };
  plugins.cmp.settings.sources = lib.optional config.plugins.cmp.enable {
    name = "vimtex";
  };
}
