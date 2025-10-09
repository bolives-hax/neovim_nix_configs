# neovim_nix_configs

### run it as standalone

```sh
git clone "https://github.com/bolives-hax/neovim_nix_configs.git"
```

and
```sh
cd neovim_nix_configs
nix run .#
# OR
nix build .#
./result/bin/nvim
```

#### good to know:
running
```sh
./result/bin/nixvim-print-init
```
prints out the cfg/init nvim will run (without all the "nix stuff") as in the
final output the nix expressions/derivation will produce
