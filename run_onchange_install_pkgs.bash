#!/usr/bin/env bash

## THIS SCRIPT MUST BE IDEMPOTENT

function main() {
    cd "$(mktemp -d)"

    install_yay

    set_up_sound

    # Install packages
    yay_install \
        firefox \
        polkit \
        fish \
        alacritty \
        less \
        bat \
        ttf-dejavu \
        ttf-jetbrains-mono \
        nerd-fonts \
        noto-fonts-cjk \
        micro \
        btop \
        tldr \
        vscodium-bin \
        fzf \
        thunar thunar-volman thunar-archive-plugin gvfs \
        telegram-desktop
        # navi
        # diff-so-fancy
        
}

function prompt() {
    msg="$1"; shift
    echo "$msg"
    read -p "Press key to continue.. " -n1 -s
}

function yay_install() {
    pkgs="$@"

    yay --sync \
        --needed \
        --noconfirm \
        $pkgs \
            2> >( grep -v "is up to date -- skipping" >&2 ) \
            | grep -v "there is nothing to do"

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

function set_up_sound() {
    # Needed for pwvucontrol
    ensure_rust

    yay_install \
        pipewire \
        wireplumber \
        pwvucontrol
}

function set_up_launcher() {
    echo ""
}

function ensure_rust() {
    yay_install rustup
    rustup toolchain install stable --no-self-update
}

main "$@"
