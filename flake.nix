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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      extraLatexSnippets,
      telescopeLuasnip,
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
          # TODO move this somewhere its just to not burn my eyes out for now
          { colorscheme = "torte"; }
          {
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
          extraSpecialArgs = { inherit extraLatexSnippets telescopeLuasnip; };
          module = self.nixvimModules.default;
        };
      });
    };
}
