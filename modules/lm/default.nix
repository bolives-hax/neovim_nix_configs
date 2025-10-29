# This module provides the neccescary plugin+setup to use LLM(large language models)
# directly in nvim. While I am one of these people who truly look down upon overreliance
# on "AI/gpt/llm/etc" as they call it. I can't deny that it is a useful tool precisely at
#
# 1) finding things in a document/text abstract you couldn't grep for
# 2) tasks too "complex" to solve using lets say sed/awk and even if you
#     could in theory solve them by writing some sort of "tool/program" to
#     do it, if you only do it once its likely a huge waste of time
#
# To anyone using my vim configuration (atm thats 2 people) please use it with care
# I personally say "LLMs are nothing but a glorified search engine" while this
# isn't exactly 100% true ... you get the point. Don't actually use this to write code
# as you will not only  never really learn how to solve problems by yourself but also
# LLM's by design have a tendency to make things up. Don't rely on it too much and
# most importantly do NOT trust its output, Always verify  its output even
# of the simplest!!!!
{lib,pkgs,gpNvim,...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "gp-nvim";
      src = gpNvim;
      #dependencies = with pkgs; [
      #];
    })
  ];

  # TODO figure out how this works
  #imports = lib.nixvim.mkNeovimPlugin {
  #  name = "gp-nvim";
  #  package = "gp-nvim";
  #};
  # TODO use an enable option for this and don't enable it by default
  # maybe even force the user to accept the disclaimer above a little like
  # with acceptACME or however it was called. Maybe call it
  # acceptThatIWillNotUseThisToDoMyTaxes and
  # acceptThatIWillNotLetThisWriteCOdeForMeOrOthers
  # I guess this ins't very "professional" of me but then its my personal neovim
  # configs after and I didn't originally plan on it having any users besides me (which now is the case ...)
  extraConfigLua = ''
    require("gp").setup({
      providers = {
        --anthropic = {
        --  endpoint = "https://nano-gpt.com/api/v1/chat/completions",
        --  -- TODO use pass or keepassxc for retriving this
        --  --secret =  os.getenv("OPENAI_API_KEY"),
        --  secret = {
        --    "pass",
        --    "show",
        --    "nanogpt_openai_api_key"
        --  },
        --},
        openai = {
          endpoint = "https://nano-gpt.com/api/v1/chat/completions",
          -- TODO use pass or keepassxc for retriving this
          --secret =  os.getenv("OPENAI_API_KEY"),
          secret = {
            "pass",
            "show",
            "nanogpt_openai_api_key"
          },
        },
      },
      agents =  {
        -- other agents (no point in disabling them as GpSelectAgent can be used to switch)
        -- and it seems to retain defaults
        {
          name = "ChatGPT-o3-mini",
          disable = true,
        },
        {
          name = "ChatGPT4o-mini",
          disable = true,
        },
        {
          name = "ChatGPT4o",
          model = { model = "chatgpt-4o-latest" },
          disable = true,
        },
        {
          name = "Gpt5Pro(NanoGPT)",
          provider = "openai",
          chat = true,
          command = false,
          model = { model = "gpt-5-pro" },
          system_prompt = "Do not simulate emotions or politeness keep the responses free from chit-chat. Assume that the responses are viewed in a terminal thus try to use ascii or commonly installed unicode characters so that it is easy to copy text using visual mode for instance. For math expressions use LaTeX. Try to use mathmatical nomenclature/naming schemes for techniques or formulas and so on (either german or english depending on in what language the user used).",
        },
        {
          name = "Gpt5ChatLatest(NanoGPT)",
          provider = "openai",
          chat = true,
          command = false,
          model = { model = "gpt-5-chat-latest" },
          system_prompt = "Do not simulate emotions or politeness keep the responses free from chit-chat. Assume that the responses are viewed in a terminal thus try to use ascii or commonly installed unicode characters so that it is easy to copy text using visual mode for instance. For math expressions use LaTeX. Try to use mathmatical nomenclature/naming schemes for techniques or formulas and so on (either german or english depending on in what language the user used).",
        },
        {
          name = "Sonnet(4_5_thinking)",
          provider = "openai",
          chat = true,
          command = true,
          model = { model = "claude-sonnet-4-5-20250929-thinking", },
          system_prompt = "Do not simulate emotions or politeness keep the responses free from chit-chat. Assume that the responses are viewed in a terminal thus try to use ascii or commonly installed unicode characters so that it is easy to copy text using visual mode for instance. For math expressions use LaTeX. Try to use mathmatical nomenclature/naming schemes for techniques or formulas and so on (either german or english depending on in what language the user used).",
          disable = false,
        },
      },
    })

    local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
    end

    --- TODO TODO V nixvim and whichkey have their own ways of defining keys, using raw lua is
    -- sort of "dirty" as its not "tracked" by nix and thus we lack out on any benefits nixvim
    -- may offer ... So TODO use them ... (This is just the bare minimum to get visual selection working)

    -- Chat commands
    vim.keymap.set({"n", "i"}, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
    vim.keymap.set({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
    vim.keymap.set({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

    vim.keymap.set({"n", "i"}, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("promt user then append after cursor"))

    -- Chat commands (using VISUAL mode's selection)
    vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
    vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
    vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

    vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual rewrite selection"))
    vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual append after selection"))
  '';
}
