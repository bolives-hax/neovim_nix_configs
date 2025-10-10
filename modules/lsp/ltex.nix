{
  config,
  pkgs,
  lib,
  ...
}:{
  plugins.lsp.servers.ltex = {
    enable = true;
  };
}
