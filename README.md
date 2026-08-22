# dotfiles — Retro Amber CRT

Chezmoi-managed dotfiles for macOS, Windows, and Debian/Kali. One palette
(`.chezmoidata/amber-crt.yaml`) drives Alacritty, Windows Terminal, Starship,
a standalone Neovim colorscheme, and four Obsidian CSS snippets, so the
theme never drifts between apps or machines.

## Bootstrap a new machine

**macOS / Debian / Kali** (Git for Windows also works with this same
command if you're bootstrapping via Git Bash):

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USER/dotfiles
```

**Windows (PowerShell)**:

```powershell
winget install twpayne.chezmoi
chezmoi init --apply YOUR_GITHUB_USER/dotfiles
```

Either way this clones the repo, installs JetBrainsMono Nerd Font
(`run_once_install-fonts.sh.tmpl`), and applies every template.

## One-time machine config: Obsidian vault paths

The Obsidian snippet deployment script needs to know where your vaults
live. This is machine-local and **not committed** — add it after the
first `chezmoi init`:

```toml
# ~/.config/chezmoi/chezmoi.toml   (macOS/Linux)
# %USERPROFILE%\.config\chezmoi\chezmoi.toml   (Windows)
[data]
obsidian_vaults = [
  "/Users/cameronhardin/Desktop/Theology",
  "/Users/cameronhardin/Desktop/Obsidian Notes",
]
```

Then re-run `chezmoi apply` — the snippets get copied into each vault's
`.obsidian/snippets/` and enabled automatically.

## Neovim colorscheme

This repo ships the colorscheme only, no plugin manager or keymaps. Add
one line to your existing Neovim config:

```lua
vim.cmd.colorscheme("amber-crt")
```

## Day-to-day workflow

```sh
chezmoi edit ~/.config/alacritty/alacritty.toml   # edit through chezmoi
chezmoi diff                                      # preview changes
chezmoi apply                                     # apply to this machine
chezmoi cd                                        # jump into the source repo to commit/push
```

On other machines, pull the latest with:

```sh
chezmoi update
```

## Layout

| Path | Deploys to |
|---|---|
| `.chezmoidata/amber-crt.yaml` | — (data only, single source of truth) |
| `.chezmoitemplates/amber-palette.tmpl` | — (shared banner for TOML configs) |
| `dot_config/alacritty/alacritty.toml.tmpl` | `~/.config/alacritty/alacritty.toml` |
| `dot_config/starship.toml.tmpl` | `~/.config/starship.toml` |
| `dot_config/nvim/colors/amber-crt.lua.tmpl` | `~/.config/nvim/colors/amber-crt.lua` |
| `AppData/Local/Packages/.../settings.json.tmpl` | Windows Terminal settings (Windows only, see `.chezmoiignore`) |
| `dot_local/share/obsidian/snippets/*.css.tmpl` | `~/.local/share/obsidian/snippets/` (canonical copies) + every vault in `obsidian_vaults` |
| `run_once_install-fonts.sh.tmpl` | Installs JetBrainsMono Nerd Font, once per machine |
| `run_onchange_after_10-deploy-obsidian-snippets.sh.tmpl` | Re-deploys snippets into vaults when the palette or vault list changes |

## Notes

- Windows Terminal and the Obsidian snippet-deploy script are `.sh`
  scripts run through Git for Windows' `sh.exe` — install
  [Git for Windows](https://gitforwindows.org/) if you haven't already.
- Alacritty doesn't support font ligatures; that's a Kitty/WezTerm feature.
