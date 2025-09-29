#!/bin/bash

HOSTNAME=$(hostname)
USER_NAME=$(id -nu 1000)

apt-get update &&

# basic apps
## with APT
echo "Installing basic apps with APT..."
apt-get install -y git alacritty telegram-desktop neofetch btop &&

## with Flatpak
flatpak install -y flathub md.obsidian.Obsidian

# HOME override!
HOME="/home/$USER_NAME"

## zed
echo "Installing Zed...to $HOME"
curl -f https://zed.dev/install.sh | sh
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.zshrc

## syncthing
curl -f https://github.com/syncthing/syncthing/releases/download/v2.0.10/syncthing-linux-amd64-v2.0.10.tar.gz ~/Downloads/syncthing-linux-amd64-v2.0.10.tar.gz
sudo tar -C '/opt' -xvf ~/Downloads/syncthing-linux-amd64-v2.0.10.tar.gz
mkdir -p .config/systemd/user
curl -f https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/linux-systemd/user/syncthing.service > ~/.config/systemd/user/syncthing.service
## TODO: Change ExecStart=/opt/syncthing/syncthing -no-browser --no-restart --logflags=0
## TODO: Run from ordinary user: systemctl --user enable --now syncthing.service

# work apps

# with APT
apt-get install -y openconnect gnome-connections

# dev apps
## uv
curl -LsSf https://astral.sh/uv/install.sh | sh

## rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
