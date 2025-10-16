## Adding a secret key

Using LMM's from within nvim usually implies having an account with some provider that compliant with the openai api spec like in my case `https://nano-gpt.com/api/v1/completions` provides. But along with specifying the location/url of the resource you also want to specify your API-key (as for now there don't seem to be providers that offer such services without needing some sort of account/api key especially not for __paid versions__)

Because I don't want to leak mine (as I don't want people I don't know burning my tokens cuz some promts are like what 1$ per request (gpt5-pro I belive) but also not provide it via an environment variable everytime I call nvim and also cause its simply bad practice to leave any sort of pw/key world-readable (`/nix/store/` is ...):

Im using [pass](https://www.passwordstore.org/) to store/retrive my pw. This assumes pass is present in your `PATH` you can add it either via

```nix
{
    environment.defaultPackages = [ pkgs.pass ];
}
```
surch an expression OR I guess use nix shell typa expressions for one time use / testing OR ose home-manager or nixvim to manage a users `PATH`/`availablePackages` etc etc.

To insert an entry to pass use `pass insert nanogpt_openai_api_key` . Ofc you can substitute `nanogpt_openai_api_key` for whatever you see fit.

Thus I use sth like:
```lua
require("gp").setup({
  providers = {
    openai = {
      endpoint = "https://nano-gpt.com/api/v1/chat/completions",
      secret = {
        "pass",
        "show",
        "nanogpt_openai_api_key"
      },
    },
  },
  -- ... other configuration options like agents = {...} and so on and on
})
```

__P.S: settings `secret = ` to something other than a lua table will instead of seeing it as a command and executing it treat it like its a plaintext declaration directly__
