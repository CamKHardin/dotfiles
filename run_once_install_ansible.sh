#!/bin/bash

set -euo pipefail

run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

install_on_linux() {
    if command -v dnf >/dev/null 2>&1; then
        run_as_root dnf install -y ansible
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        run_as_root apt-get update
        run_as_root apt-get install -y ansible
        return
    fi

    if command -v pacman >/dev/null 2>&1; then
        run_as_root pacman -Sy --noconfirm ansible
        return
    fi

    if command -v zypper >/dev/null 2>&1; then
        run_as_root zypper --non-interactive install ansible
        return
    fi

    if command -v apk >/dev/null 2>&1; then
        run_as_root apk add ansible
        return
    fi

    echo "Unsupported Linux distribution: no supported package manager found for Ansible install."
    exit 1
}

install_on_macos() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is required on macOS to install Ansible."
        exit 1
    fi
    brew install ansible
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        install_on_linux
        ;;
    Darwin*)
        install_on_macos
        ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

PLAYBOOK_PATH=""
if [ -f "$HOME/.bootstrap/setup.yml" ]; then
    PLAYBOOK_PATH="$HOME/.bootstrap/setup.yml"
elif [ -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dot_bootstrap/setup.yml" ]; then
    PLAYBOOK_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dot_bootstrap/setup.yml"
else
    echo "Unable to find setup.yml playbook."
    exit 1
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
    echo "ansible-playbook was not found after installation."
    exit 1
fi

ansible-playbook "$PLAYBOOK_PATH" --ask-become-pass

echo "Ansible installation complete."
