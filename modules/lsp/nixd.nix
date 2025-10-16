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
      # TODO WHY IS THIS NOT WORKING in any variation
      options = {
        nixvim.expr = ''(builtins.getFlake(toString /home/flandre/nixvim)).inputs.nixvim.nixvimConfigurations.x86_64-linux.default.options'';
      };
    };
    filetypes = [ "nix" ];
    #extraOptions =
  };
  extraPackages = [ pkgs.nixfmt ];

}
