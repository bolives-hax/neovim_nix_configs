{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    extraLatexSnippets = {
      url = "github:bolives-hax/latex-luasnips";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      extraLatexSnippets,
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
          extraSpecialArgs = { inherit extraLatexSnippets; };
          module = self.nixvimModules.default;
        };
      });
    };
}
