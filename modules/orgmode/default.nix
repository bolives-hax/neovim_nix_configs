{config,lib,telescopeOrgmode,pkgs,...}: {
  extraPlugins = lib.optionals config.plugins.telescope.enable [
    (pkgs.vimUtils.buildVimPlugin {
      name = "telescope-orgmode.nvim";
      src = telescopeOrgmode;
      dependencies = with pkgs; [
        vimPlugins.orgmode
        vimPlugins.telescope-nvim
        vimPlugins.plenary-nvim
      ];
    })
  ];
  plugins.orgmode = {
    enable = true;
    settings = {
      # TODO ofc you may want to sync that
      org_agenda_files = "~/orgmode-synced/**/*";
      org_default_notes_file = "~/orgmode-synced/refile.org";
    };
  };
  plugins.cmp.settings.sources = lib.optional config.plugins.cmp.enable {
    name = "luasnip";
    show_autosnippets = true;
  };
  plugins.telescope = {
    enabledExtensions = [ "luasnip" "orgmode" ];
  };
}
