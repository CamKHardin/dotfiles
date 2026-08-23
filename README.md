# dotfiles

Chezmoi-managed dotfiles plus an Ansible bootstrap.
Cross-platform target: Linux (Fedora/Debian/Arch/openSUSE family) and macOS.

## Use it

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply CamKHardin
```

What happens:
- `run_once_install_ansible.sh` installs Ansible via your system package manager and runs the bootstrap playbook
- `run_onchange_bootstrap.sh.tmpl` re-runs bootstrap when `dot_bootstrap/setup.yml` changes
- `run_once_install_ohmyzsh.sh` installs Oh My Zsh once
- Brave + Docker are configured for Fedora and Debian/Ubuntu flows

## Operate it

- Re-apply dotfiles: `chezmoi apply`
- Preview changes: `chezmoi diff`
- Edit managed files: `chezmoi edit <target-path>`
- Pull a change: `chezmoi update`

## Common change workflows

### Change your zsh look and save it in chezmoi

1. Open the source repo: `chezmoi cd`
2. Edit zsh source files (usually `dot_zshrc`, and theme files like `amber-crt.zsh-theme`)
3. Preview/apply locally:
   - `chezmoi diff`
   - `chezmoi apply`
4. Commit and push this repository

If you changed `~/.zshrc` directly instead of editing source, import it back first:

```sh
chezmoi add ~/.zshrc
```

### Add another app to auto-install via Ansible bootstrap

1. Edit `/home/runner/work/dotfiles/dotfiles/dot_bootstrap/setup.yml`
2. Add the package to the correct list:
   - Linux: `linux_packages_by_family` for each OS family you want
   - macOS: `macos_packages`
3. If it needs a custom repo/key, add distro-conditional tasks (see Brave/Docker blocks as examples)
4. Validate playbook syntax:
   - `ansible-playbook --syntax-check dot_bootstrap/setup.yml`
5. Run bootstrap:
   - `chezmoi apply` (triggers `run_onchange_bootstrap.sh.tmpl` when bootstrap changed), or
   - `ansible-playbook dot_bootstrap/setup.yml --ask-become-pass`
6. Commit and push this repository

## Extend it

- Add one-time bootstrap steps: add `run_once_*` scripts
- Add rerun-on-change steps: add `run_onchange_*` scripts/templates
