{config,lib,pkgs,...}: let
  keybinds = {
    grep = "<leader>tfg";
    grepHome = "<leader>tfG";
    files = "<leader>tff";
    buffers = "<leader>tfb";
  };
in {
  plugins = {
    telescope = {
      enable = true;
      extensions = {
        live-grep-args.enable = true;
      };
    };
  };
  extraPackages = with pkgs; [
    ripgrep
  ];
  plugins.which-key = {
    settings = {
      spec = [
        { __unkeyed = "<leader>t"; desc = "Telescope"; }
        { __unkeyed = "<leader>tf"; desc = "Find"; }

        { __unkeyed = keybinds.grep; desc = "grep (live)"; }
        { __unkeyed = keybinds.grepHome; desc = "grep ~/ (live grep $HOME)"; }
        { __unkeyed = keybinds.files; desc = "files"; }
        { __unkeyed = keybinds.buffers; desc = "buffers"; }
      ];
    };
  };
  keymaps =
    # if action = mkRaw's lua -> it must be either a string OR a lua function. So make sure you
    # dont pass something that was already called like:
    # "action = some_plugin_idk"
    # instead of:
    # "action = some_plugin_idk()"  <---- which will crash eventhough it "compiles"
    [{
      # V live_grep_args extensions allows us to provide args to rg unlike telescopes builtin live_grep.
      #   thus you can hit "<leader>tff" and then enter something like: "your search query" /var to search for
      #   it in /var . Or omit the /var to just search in the CWD(current working directory) of nvim
      #   which usually is $PWD of the shell you called nvim from. Useful if you want to find files outside
      #   where ":!pwd" lies ...
      action = lib.nixvim.mkRaw ''
        function ()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end
      ''; # function () is reuqired as action (when its lua type) needs to be a function thus you can't pass
      # action = lib.nixvim.mkRaw "require('telescope.builtin').live_grep";
      key = keybinds.grep;
    }
    {
      # if you like me frequently end up searching for things in your ~/ home directory ... its useful to have the means to
      # search it without having to type /home/user/ into the previous described live_grep_args / (keybinds.grep)
      # Telescope window. Also typing $HOME into live_grep_args Telescope popup does not resolve variables such as $HOME
      # which means one has to type /home/user/ by hand which is sort of annoying. Hardcoding the homedir is obviously even
      # more disencourages so this function sort of aims to close the gap
      action = lib.nixvim.mkRaw ''
        function ()
          -- TODO by default this seems to include ~/.* as in "hidden files/dotfiles" ... find a way to toggle this maybe
          require("telescope").extensions.live_grep_args.live_grep_args({
          -- TODO maybe split this into 2 more bindings that in/exclude certain directories from the search
          --      like pass files or such if you record your terminal and publish it. But then honestly
          --      you should never store passwords in plainstext BUT afaik "pass"'s passwordstore lets say
          --      still shows usernames. Irrelevant in my case as I use PQC and have the encrypted pass publicly
          --      tracked via git ... but others may not AND sometimes filenames can still reveal private data
          --      or .torrent files may have lets say keys. Best approach may be to add a "record" mode that
          --      has some privacy features set by default. Or honestly just use a different user as bootstrapping
          --      this with Nix(nixvim) is trivial and can be done nearly wherever
          search_dirs = {'$HOME'},
        })
        end
      '';
      key = keybinds.grepHome;
    }
  ] ++ [
    {
      action = lib.nixvim.mkRaw "require('telescope.builtin').find_files";
      key = keybinds.files;
    }
    {
      action = lib.nixvim.mkRaw "require('telescope.builtin').buffers";
      key = keybinds.buffers;
    }
  ];
}
