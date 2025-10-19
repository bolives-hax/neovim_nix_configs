{ config, lib, ... }: let
  keybinds = {
    diagnosticsOpen = "<leader>do";
    telescopeDiagnostics = "<leader>td";
    # I chose not to use "<leader>d] and d[" because is harder to reach on workman
    diagnosticsNext = "<leader>dn";
    diagnosticsPrev = "<leader>dp";
  };
in {
  # plugin that gives some insight into what neovim
  # (specifically lsp in our case) is doing in the bottom
  # right corner. E.g if nixd evaluates stuff or rust-analyzer
  plugins.fidget = {
    enable = true;
  };
  plugins.lsp = {
    enable = true;
    inlayHints = true;
  };

  plugins.cmp.settings.sources = lib.optional config.plugins.cmp.enable {
    name = "nvim_lsp";
  };

  # TODO V configure this according to https://github.com/iamcco/diagnostic-languageserver
  #plugins.lsp.servers.diagnosticls = {
  #  enable = true;
  #};
  # TODO use the nixvim autocmd and try to place this in its own file
  extraConfigLua = /*''
    function PrintDiagnostics(opts, bufnr, line_nr, client_id)
      bufnr = bufnr or 0
      line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
      opts = opts or {['lnum'] = line_nr}

      local line_diagnostics = vim.diagnostic.get(bufnr, opts)
      if vim.tbl_isempty(line_diagnostics) then return end

      local diagnostic_message = ""
      for i, diagnostic in ipairs(line_diagnostics) do
        diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
        print(diagnostic_message)
        if i ~= #line_diagnostics then
          diagnostic_message = diagnostic_message .. "\n"
        end
      end
      vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
    end
    --vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]
    */''

    local group = vim.api.nvim_create_augroup('OoO', {})


    -- when entering insert mode turn of diagnostics so they don't get in the way
    vim.api.nvim_create_autocmd(
    {"InsertEnter"},
    {
      pattern = nil,
      --command = function ()
      callback = function ()
        vim.diagnostic.enable(false)
      end,
      group = group,
    })

    -- crude way to ensure that after issuing ${keybinds.diagnosticsOpen}
    -- moving or entering insert mode etc etc will remove set tracking variable
    -- to false so that upon idling and such the reduced dianostics will be
    -- shown again automatically.
    vim.api.nvim_create_autocmd(
    {"CursorMoved","BufLeave","InsertEnter"},
    {
      pattern = nil,
      --command = function ()
      callback = function ()
        vim.g.diagnostics_are_opened_manually = false
      end,
      group = group,
    })

    -- when leaving insert mode turn on the diagnostics again
    vim.api.nvim_create_autocmd(
    {"InsertLeave"},
    {
      pattern = nil,
      --command = function ()
      callback = function ()
        vim.diagnostic.enable(true)
      end,
      group = group,
    })

    -- open the diagnostics window
    vim.api.nvim_create_autocmd(
      -- Holding the cursor for long enough on a warning/error/... diagnostic
      -- will display it, but you can also hit ${keybinds.diagnosticsOpen}
      {"CursorHold", "InsertLeave"},
      {
        pattern = nil,
        --command = function ()
        callback = function ()
          local opts = {
            focusable = false,
            scope = 'cursor',
            close_events = {
              'BufLeave',
              'CursorMoved',
              'InsertEnter',
            },
          }
          -- don't open this reduced diagnostic float if the user already opened this manually
          if not vim.g.diagnostics_are_opened_manually then
            vim.diagnostic.open_float(nil, opts)
          end
        end,
        group = group,
      }
    )

    vim.diagnostic.config({
      virtual_text = {
        -- source = "always",  -- Or "if_many"
        prefix = '●', -- Could be '■', '▎', 'x'
      },
      severity_sort = true,
      float = {
        source = "always",  -- Or "if_many"
      },
    })'';

  keymaps = [
    {
      action = lib.nixvim.mkRaw ''function ()
        -- If CursorHold will display diagnostics when the cursor dosen't move
        -- but at the same time the user opened them manually (which shows an extended view)
        -- the autocomand of CursorOpen will cause the manually opened float to be
        -- closed and the reduced CursorHold triggered one to be shown instead which is
        -- irritating. Thus we use vim.g.diagnostics_are_opened_manually to track it
        vim.g.diagnostics_are_opened_manually = true
        vim.diagnostic.open_float()
      end
      '';
      key = keybinds.diagnosticsOpen;
    }
    {
      action = lib.nixvim.mkRaw "vim.diagnostic.goto_next";
      key = keybinds.diagnosticsNext;
    }
    {
      action = lib.nixvim.mkRaw "vim.diagnostic.goto_prev";
      key = keybinds.diagnosticsPrev;
    }
    {
      action = lib.nixvim.mkRaw "require('telescope.builtin').diagnostics";
        # TODO V check if telescope is enabled before adding this
      key = keybinds.telescopeDiagnostics;
    }
  ];
  plugins.which-key = {
    settings = {
      spec = [
        { __unkeyed = "<leader>d"; desc = "Diagnostics"; }
        { __unkeyed = keybinds.diagnosticsOpen; desc = "Open"; }
        { __unkeyed = keybinds.diagnosticsNext; desc = "Next diagnostic"; }
        { __unkeyed = keybinds.diagnosticsPrev; desc = "Previous diagnostic"; }
        # TODO V check if telescope is enabled before adding this
        { __unkeyed = keybinds.telescopeDiagnostics; desc = "Diagnostics (lsp)"; }
      ];
    };
  };
  imports = [
    ./nixd.nix
    # TODO do I actually need ltex if i got ltex
    #./ltex.nix
    ./bash.nix
  ];
}
