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
