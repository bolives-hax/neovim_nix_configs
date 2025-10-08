{ config, lib, ... }:
{
  # TODO throw a warning or fail when lsp isn't also setup maybe
  #       and also throw a warning from lsp if cmp isn't setup
  plugins.cmp = {
    enable = true;
    autoEnableSources = true; # false;
    settings = {
      completion = {
        # V kthe default value
        #autocomplete = [
        #  "require('cmp.types').cmp.TriggerEvent.TextChanged"
        #];
        keyword_length = 0;
      };
      mapping = {
        # V "enter/return -> cmp select
        "<CR>" =
          let
            lsHook =
              action:
              if config.plugins.cmp_luasnip.enable then
                ''
                  if require("luasnip").expandable() then
                      require("luasnip").expand()
                  else
                      ${action}
                  end
                ''
              else
                ''
                  ${action}
                '';
          in
          ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                ${lsHook "cmp.confirm({ select = true, })"}
              else
                  fallback()
              end
            end)'';

        # go trough cmp suggestion list
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" })
        '';

        # shift+tab -> go trough cmp suggestion list (backwards)
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" })
        '';

        # (modifier[Alt] + space) -> jump trough snippet fields
        "<M-Space>" = ''
          cmp.mapping(function(fallback)
          if require("luasnip").locally_jumpable(1) then
            require("luasnip").jump(1)
          else
            fallback()
          end
          end, { "i", "s" })
        '';

        # (Shift + modifier[Alt] + space)
        # > jump trough snippet fields(backwards)
        "<M-S-Space>" = ''
          cmp.mapping(function(fallback)
          if require("luasnip").locally_jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
          end, { "i", "s" })
        '';

        # some snippets have multiple choices such as
        # itbn "double integral" =>
        #   1) \\  iint
        #   2) \\ niint
        #
        # LuaSnip puts us into Select mode <similar to visual mode>
        # if a snippet has choices but no fields as int \iint OR \oiint
        # but not \iint{} ] where {} takes a param like \iint{a} or \iint{b}
        # thus in this case you need to hit ls.choice_active() to not replace
        # the snippeted expression
        # [or Esc and go back to (i)nsert but thats SLOW]
        # Ctrl + E (snippet choice cycle forward)
        "<C-E>" = ''
          cmp.mapping(function(fallback)
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(1)
            else
              fallback()
            end
            end, { "i", "s" })
        '';

        # TODO decide if you really need the backwards form as tbh 99% of
        # snippets have 1 to max 2 forms. Very rarely there are +2
        # Ctrl + O ( snippet choice cycle backwards)
        "<C-O>" = ''
          cmp.mapping(function(fallback)
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(-1)
            else
              fallback()
            end
            end, { "i", "s" })
        '';

      };
      formatting = {
        fields = [
          "kind"
          "abbr"
          "menu"
        ];
        format = ''
          function(entry, vim_item)
            local kind_icons = {
              Text = "󰊄",
              Method = "",
              Function = "󰡱",
              Constructor = "",
              Field = "",
              Variable = "󱀍",
              Class = "",
              Interface = "",
              Module = "󰕳",
              Property = "",
              Unit = "",
              Value = "",
              Enum = "",
              Keyword = "",
              Snippet = "",
              Color = "",
              File = "",
              Reference = "",
              Folder = "",
              EnumMember = "",
              Constant = "",
              Struct = "",
              Event = "",
              Operator = "",
              TypeParameter = "",
            }
              
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.menu = ({
            	path = "[Path]",
            	nvim_lua = "[NVIM_LUA]",
            	nvim_lsp = "[LSP]",
            	luasnip = "[Snippet]",
            	vimtex = "[vimtex]",
            	buffer = "[Buffer]",
                  speling = "[SPELL]";
            })[entry.source.name]
            return vim_item
          end
        '';
      };

    };
  };

  # needed to give cmp the ability to use lsp as a completion source
  plugins.cmp-nvim-lsp = {
    enable = true;
  };
}
