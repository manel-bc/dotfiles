#!/usr/bin/env bash

## THIS SCRIPT MUST BE IDEMPOTENT

function main() {
    cd "$(mktemp -d)"

    install_yay

    set_up_fish
    set_up_sound
    set_up_ssh_agent
    set_up_steam

    # properly install and configure nerd font, emojis and asian font

    # Install packages
    yay_install \
        firefox \
        polkit \
        alacritty \
        less \
        bat \
        ttf-jetbrains-mono \
        micro \
        btop \
        tldr \
        vscodium-bin \
        fzf \
        thunar thunar-volman thunar-archive-plugin gvfs \
        telegram-desktop \
        waybar \
        man
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
    sudo sed -i 's/#Color/Color/' /etc/pacman.conf

    if type yay >/dev/null 2>&1
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
    yay_install fish

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

function set_up_ssh_agent() {
    systemctl --user enable ssh-agent
    systemctl --user start ssh-agent
}

function set_up_steam() {
    if type steam >/dev/null 2>&1; then
        return
    fi
    # CHECK IS STEAM IS ALREADY INSTALLED

    # Enable multilib for 32 pkgs
    sudo sed -zi 's@#\[multilib\]\n#Include = /etc/pacman.d/mirrorlist@\[multilib\]\nInclude = /etc/pacman.d/mirrorlist@' /etc/pacman.conf
    yay -Sy --noconfirm

    echo "Verify GPU driver in use:"
    lspci -v | grep -A 10 VGA

    yay -S steam

    sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    sudo locale-gen
}

main "$@"
