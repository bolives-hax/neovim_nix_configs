{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.autosave-nvim ];
  extraConfigLua = ''
	require('autosave').setup({
		plugin = {
		    force = false, -- Whether to forcefully write or not (:w!)
		},
		events = {
		    register = true, -- Should autosave register its autocommands
		    triggers = { -- The autocommands to register, if enabled
		        'InsertLeave',
		        'TextChanged',
		        'TextChangedI',
		        --'CursorHold'
		    }
		},
		debounce = {
		    enabled = true, -- Should debouncing be enabled
		    delay = 250 -- If enabled, only save the file at most every `delay` ms
		},
		filters = { -- The filters to apply, see above for all options.
		    -- These filters are required for basic operation as they prevent
		    -- errors related to to buffer state.
		    require('autosave.filters').writeable,
		    require('autosave.filters').not_empty,
		    require('autosave.filters').modified,
		    require('autosave.filters').invert(require('autosave.filters').filetype("tex"))
		},
		hooks = {
		    on_enable = nil,   -- Called when the plugin is enabled for the first time.
		    pre_filter = nil,  -- Called before the write sequence begins. (This happens before filter checks)
		    pre_write = nil,   -- Called before the buffer is written (This happens after all checks pass)
		    post_write = nil,  -- Called after the write sequence. (This happens after the buffer has been saved)
		}
	})
'';
}
