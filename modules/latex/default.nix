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
        # see ./README.md for a detailed explaination of caveats
        compiler_latexmk = {
          # callback = 1; # disables the error-callback described in ./README.md
          # but also eliminates error reporting entirely ... which is more than suboptimal
          emulate_aux = 1;
          # V place various files creates during the build (such as a .log file)
          #   into a dedicated aux directory, this reduces artifact-clutter
          aux_dir = "aux";
          build_dir = "";
          options = [
            "-pdf"
            # VERY IMPORTANT!!!
            # V this ensures that pdflatex when called will -file-line-error
            # V which according to  its man page "Print error messages in the form
            #   file:line:error which is similar to the way many compilers format them"
            #
            # V   this is needed because otherwise certain errors
            "-file-line-error" # very important!
            # V sometimes the LaTeX compiler needs more than 2 runs which
            #   happens to be the default. It will fail if it does which Vimtex doens't
            #   understand and this manifests with the same sorta popup as
            #   for -file-line-error where it can't parse the logfile properly
            "-e '$max_repeat=500'" # what may be a sane value? Dunno lets just go overkill
            #                         it dosen't seem to do any "harm" as it seems?!
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
