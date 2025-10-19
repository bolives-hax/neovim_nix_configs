{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    extraLatexSnippets = {
      # main is the original branch BUT since i discovered
      # cmp.select_next_item({behavior = cmp.SelectBehavior.Select}) instead of insert
      # its no longer needed to maintain a modified snippet collection since they wont
      # accidentially get auto applied anymore
      url = "github:bolives-hax/latex-luasnips/main";
      flake = false;
    };

    telescopeLuasnip = {
      url = "github:benfowler/telescope-luasnip.nvim";
      flake = false;
    };
    telescopeOrgmode = {
      url = "github:nvim-orgmode/telescope-orgmode.nvim";
      flake = false;
    };
    gpNvim = {
      url = "github:Robitx/gp.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      extraLatexSnippets,
      telescopeLuasnip,
      telescopeOrgmode,
      gpNvim,
    }:
    let
      systems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      nixvimModules.default = {
        imports = [
          ./modules/lsp/default.nix
          ./modules/cmp/default.nix
          ./modules/luasnip/default.nix
          ./modules/latex/default.nix
          ./modules/telescope/default.nix
          ./modules/autosave/default.nix
          ./modules/nix/default.nix
          ./modules/orgmode/default.nix
          ./modules/whichkey/default.nix
          ./modules/lm/default.nix
          # TODO move this somewhere its just to not burn my eyes out for now
          { colorscheme = "torte"; }
          # V in case something breaks this makes it harder to refer to the source as
          # V it will be present in a compiled format ... TODO maybe find a way to
          # V "add debug symbols" or something? Or add a separate input that by default
          # V disables this BUT using --override-input-attrs can be enabled ... I don't
          # V know the correct way as for now
          { performance.byteCompileLua.enable = true; }
          # V seems to break some things and honestly it doesn't help too much teaching
          #   you more than the very basics. I mostly struggle with using the most efficient
          #   motions
          #{ plugins.hardtime.enable = true; }
          {
            keymaps = [
              # TODO can we put leader here?!
            ];
          }
          {
            globals = {
              # funnily enough setting this to <Space> wont work while setting it
              # to " " as in actual space ascii char will ...
              mapleader = " ";
            };
            opts = {
              # display horizontal and vertical bar trough the cursor
              # to aid visually locating the cursor at all times
              cursorline = true;
              cursorcolumn = true;

              # display current line number + relative number ordering to cursor
              number = true;
              relativenumber = true;
            };
          }
        ];
      };
      packages = forAllSystems (system: {
        default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
          extraSpecialArgs = { inherit extraLatexSnippets telescopeLuasnip telescopeOrgmode gpNvim;};
          module = self.nixvimModules.default;
        };
      });
    };
}
