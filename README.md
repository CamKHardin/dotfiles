# dotfiles

Chezmoi-managed dotfiles plus an Ansible bootstrap.
Primary target: Fedora.

## Use it

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply CamKHardin
```

What happens:
- `run_once_install_ansible.sh` installs Ansible and runs the bootstrap playbook
- `run_onchange_bootstrap.sh.tmpl` re-runs bootstrap when `dot_bootstrap/setup.yml` changes
- `run_once_install_ohmyzsh.sh` installs Oh My Zsh once

## Operate it

- Re-apply dotfiles: `chezmoi apply`
- Preview changes: `chezmoi diff`
- Edit managed files: `chezmoi edit <target-path>`

## Extend / edit it

- Shell/editor/app configs: edit `dot_*` files and templates in this repo
- System packages/setup tasks: edit `/home/runner/work/dotfiles/dotfiles/dot_bootstrap/setup.yml`
- Add one-time bootstrap steps: add `run_once_*` scripts
- Add rerun-on-change steps: add `run_onchange_*` scripts/templates