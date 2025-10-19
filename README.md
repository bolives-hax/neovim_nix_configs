# neovim_nix_configs

## setup/installation
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

## "must know" keybinds
Note keybinds are expressed like this:

`a -> b -> c` press `a` then `b` and then `c`
and
`a + b -> c` press `a` AND `b` at the same time THEN (like after releasing `a+b` press `c`)

`<CR>` stands for "carriage return" and just means `enter`|`return`|`newline`

### Finding files

To find files I advise to mostly use "Telescope" the following keybinds are configured:

To find files (as in by their **filename** NOT their content) in the directory nvim was ran from __(You can see it via running `:!pwd` for example)__

```
space -> t -> f -> f
```

to find files (by their **content** NOT their filename) __(in the directory nvim was ran from)__

```
space -> t -> f -> g
```

to find files (by their **content** NOT their filename) __(in ~/ as defined by $HOME)__

```
space -> t -> f -> G
```

##  good to know:
running
```sh
./result/bin/nixvim-print-init
```
prints out the cfg/init nvim will run (without all the "nix stuff") as in the
final output the nix expressions/derivation will produce

## TODO

include various nested README.md's here as their existence is almost pointless if the user forgets to look at them
