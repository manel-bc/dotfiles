#!/usr/bin/env bash

## THIS SCRIPT MUST BE IDEMPOTENT

function main() {
    cd "$(mktemp -d)"

    install_yay

    # Install packages
    yay --sync \
        --needed \
        --noconfirm \
        firefox \
        polkit \
        fish \
        cool-retro-term \
        less
        # bat
        # micro
        # tldr
        # navi
        # fzf
        # btop
        # diff-so-fancy
        # vscodium-bin
}

function prompt() {
    msg="$1"; shift
    echo "$msg"
    read -p "Press key to continue.. " -n1 -s
}

function install_yay() {
    if command -v yay >/dev/null 2>&1
    then
        return
    fi

    sudo pacman -S --noconfirm \
        --needed git base-devel \
        && git clone https://aur.archlinux.org/yay-bin.git \
        && cd yay-bin \
        && makepkg -si
}

function set_up_fish() {
    # Disable greeting
    fish -c "set -U fish_greeting"
}

main "$@"
