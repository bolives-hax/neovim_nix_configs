{ config, pkgs, lib, ... }:
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
      # as this is a "note taking setup" I don't exactly care about the
      # package count. For anything one would "release" just make a
      # standalone drv and choose the latex package dependencies selectively
      texlivePackage = pkgs.texlive.combined.scheme-full;
      settings = {
        quickfix_open_on_warning = 0;
        # TODO these don't seem to work ...
        quickfix_ignore_filters = [
          "Underfull \\hbox"
          "Overfull \\hbox"
          "LaTeX Warning: .\\+ float specifier changed to"
          "LaTeX hooks Warning"
          "Package siunitx Warning: Detected the \"physics\" package:"
          "Package hyperref Warning: Token not allowed in a PDF string"
        ];
        view_method = "zathura";
        compiler_latexmk = {
          # V place various files creates during the build (such as a .log file)
          #   into a dedicated aux directory, this reduces artifact-clutter
          aux_dir = "aux";
          build_dir = "";
          options = [
            "-pdf"
            # V this seems to help VimTex creating a popup that makes
            #   luasnip stop (TODO doesn't reliably work it seems to
            # have reduced the occurances of this error by 70% but that may just
            # be my imagination.... I'm not even 1000% sure if this setting is being
            # respect at all, guess I'll have to find out)
            # TODO after figuring out the actual issue set this to a sane value that prevents
            # us from ever seeing this popup that break Vixtex/Luasnip
            "-e '$max_repeat=500'"
            "-interaction=nonstopmode"
            # TODO what do these do again (they were taken from old cfg)
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
        # without setting this to =2, selecting completion symbol items
        # (if they poses an unicode symbol like used in julia ig) will cause
        # the actual symbol instead of the LaTeX command for it being inserted
        # inplace which not only this editor isn't configured to deal with (Vimtex specific commands/lsp/...)
        # but also the latex compiler will complain and honestly it also sort of defeats the point of using
        # latex in some instences (and ofc add even more requirements in regards to the terminal capabilities
        # needed for this nvim instance to run in ... lets try to keep it ascii or MOSTLY ascii!)
        strategy = 2;
      };
    }
  ];
}
