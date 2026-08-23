#!/bin/bash

set -euo pipefail

install_on_fedora() {
    sudo dnf install -y ansible
}

install_on_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y ansible
}

install_on_mac() {
    brew install ansible
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/fedora-release ]; then
            install_on_fedora
        elif [ -f /etc/lsb-release ]; then
            install_on_ubuntu
        else
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
    Darwin*)
        install_on_mac
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

ansible-playbook "$PLAYBOOK_PATH" --ask-become-pass

echo "Ansible installation complete."
