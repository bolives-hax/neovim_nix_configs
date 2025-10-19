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
        autocomplete = [
          "require('cmp.types').cmp.TriggerEvent.TextChanged"
        ];
        keyword_length = 0;
      };
      mapping = {
        # V "enter/return -> cmp select , note that expanding a snippet
        # doesn't mean "accepting" one of the muliple "choices" that a
        # luansip-snippet may present given:
        # =======> require("luasnip").choice_active() = true
        #
        # but rather you will want to use require("luasnip").jump(1) to place
        # the cursor behind the selected choice and leave SELECT mode. If you
        # were to use <CR> => require("luasnip").expand() instead it would
        # simply delete the SELECT'ed  choice ..... <CR> is only for accepting
        # the core snippet presented by cmp NOT for "accepting" a
        # luasnip-snippet-choices-"coice"
        # Lets say you got "itbn" which may either be \iint or \oiint
        # depending on what you select via require("luasnip").change_choice(+-1)
        # you will see "\iint" or "\oiint" selected and SELECT as the mode in the corner
        # to then continue instead of discarding it press what maps to luasnips .jump()
        "<CR>" =
          let
            # TODO what does select=true|false even do? I believe i misunderstood
            # it and what somebody suggested was rather the way i used it on
            # cmp_select_next( { behavior = cmp.SelectBehaviorSelect } )
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
          # -- According to doc: Accept currently selected item.
          # Set `select` to `false` to only confirm explicitly selected items.
          # TODO but this doens't seem to change any behavior?! why is that
          ''
            cmp.mapping(function(fallback)
              -- the "and" before "cmp.get_active_entry()" is very
              -- important! as it prevents completion entries specifically
              -- snippets to be applied by pressing <CR>=enter/return as
              -- I want to retain the ability to use <CR> to insert newlines
              -- without having to put a space at the end of the line and then
              -- press <CR> as opposed to being able to press cr in any situation
              -- as long as I didn't use <TAB> to INTENTIONALLY an cmp(completion)
              -- entry from the list.
              if cmp.visible() and cmp.get_active_entry() then
                ${lsHook "cmp.confirm(
                {
                  select = false,
                  -- TODO I forgot why I put replace here ... find out
                  -- what my intention behind this was again
                  behavior = cmp.ConfirmBehavior.Replace
                })"}
              else
                  fallback()
              end
            end)'';

        # go trough cmp suggestion list
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              -- this prevents snippets from being applied unintentionally merelyby cycling
              -- trough them lie it would be the case in the absence of "behavior = ...Select"
              -- though if your cmp.confirm() is prefixed with an "cmp.visible() and cmp.get_active_entry()"
              -- check "cmp.get_active_entry()" technically seen should prevent this from occuring as well
              -- but I'm including it regardless in case I want to change the behavior one day so I avoid confusion
              cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
            else
              fallback()
            end
          end, { "i", "s" })
        '';

        # shift+tab -> go trough cmp suggestion list (backwards)
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              -- this prevents snippets from being applied unintentionally merelyby cycling
              -- trough them lie it would be the case in the absence of "behavior = ...Select"
              -- though if your cmp.confirm() is prefixed with an "cmp.visible() and cmp.get_active_entry()"
              -- check "cmp.get_active_entry()" technically seen should prevent this from occuring as well
              -- but I'm including it regardless in case I want to change the behavior one day so I avoid confusion
              cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
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
