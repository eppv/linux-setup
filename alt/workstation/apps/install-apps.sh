#!/bin/bash

HOSTNAME=$(hostname)
USER_NAME=$(id -nu 1000)

apt-get update &&

# basic apps
## with APT
echo "Installing basic apps with APT..."
apt-get install -y eepm git telegram-desktop fastfetch btop &&

## with Flatpak
# flatpak install -y flathub md.obsidian.Obsidian
# it is not recommended way to install Obsidian, now the best way is to install by epm

## with epm
epm play yandex-browser
epm play obsidian

# HOME override!
HOME="/home/$USER_NAME"

## zed
echo "Installing Zed...to $HOME"
curl -f https://zed.dev/install.sh | sh
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.zshrc

# work apps

# with APT
apt-get install -y openconnect
