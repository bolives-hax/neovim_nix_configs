{ config, lib, ... }:
{
  plugins = {
    # completions for vimtex
    cmp-vimtex = {
      enable = true;
    };
    cmp-latex-symbols = {
      enable = true;
    };
    # vimtex (provides lotsa helpers to work with LaTeX)
    vimtex = {
      enable = true;
      settings = {
        view_method = "zathura";
        vimtex_compiler_latexmk = {
          build_dir = "";
          options = [
            "-pdf"
            # V this seems to help VimTex creating a popup that makes
            #   luasnip stop
            "$max_repeat=50"
            "-interaction=nonstopmode"
            "-synctex=1"
            "-pvc"
          ];
        };
      };
    };
  };
  plugins.cmp.settings.sources = lib.optionals config.plugins.cmp.enable [
    { name = "vimtex"; }
    {
      name = "latex_symbols";
      option = {
        strategy = 2;
      };
    }
  ];
}
