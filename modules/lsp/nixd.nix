{
  config,
  pkgs,
  lib,
  ...
}:
with lib.nixvim;
{
  plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
      nixpkgs = mkRaw "\"import (builtins.getFlake(toString ./.)).inputs.nixpkgs {}\"";
      formatting = {
        command = [ "nixfmt-rfc-style" ];
      };
      options = {
        nixvim.expr = ''import (builtins.getFlake(toString ./.)).inputs.nixvim.nixvimConfigurations.x86_64-linux.default.options'';
      };
    };
    filetypes = [ "nix" ];
    #extraOptions =
  };
  extraPackages = [ pkgs.nixfmt ];

}
