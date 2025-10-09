{
  config,
  pkgs,
  lib,
  extraLatexSnippets,
  telescopeLuasnip,
  ...
}:
{
  plugins = {
    cmp_luasnip = {
      enable = true;
    };
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        snippets.expand = lib.nixvim.mkRaw ''
          function(args)
            require("luasnip").lsp_expand(args.body)
          end
        '';
        # seems to be broken or not do what i want ...
        #fromLua = [
        #  {
        #    include = ["tex"];
        #    paths = /home/flandre/latex-luasnips/snippets; #"/home/flandre/latex-luasnips/snippets/";
        #  }
        #];
      };

      luaConfig.post = ''
        require("luasnip.loaders.from_lua").load({
          paths = {
            "${extraLatexSnippets}/snippets",
          }
        })
      '';
      filetypeExtend = {
        tex = [
          "tex"
        ];
      };
    };
  };
  plugins.cmp.settings.sources = lib.optional config.plugins.cmp.enable {
    name = "luasnip";
    show_autosnippets = true;
  };
  plugins.telescope = {
    enabledExtensions = [ "luasnip" ];
  };
  extraPlugins = lib.optionals config.plugins.cmp.enable [
    (pkgs.vimUtils.buildVimPlugin {
      name = "telescopeLuasnip";
      src = telescopeLuasnip;
    })
  ];
}
