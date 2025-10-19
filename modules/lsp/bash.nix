{
  config,
  pkgs,
  lib,
  ...
}:
with lib.nixvim;
{
  plugins.lsp.servers.bashls = {
    enable = true;
    #
    #filetypes = [  ];
  };
  extraPackages = [  ];

}
