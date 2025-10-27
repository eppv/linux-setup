#!/bin/bash

HOSTNAME=$(hostname)
USER_NAME=$(id -nu 1000)

apt-get update &&

# basic apps
## with APT
echo "Installing basic apps with APT..."
apt-get install -y eepm git telegram-desktop neofetch btop &&

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


# golang
curl -sf https://go.dev/dl/go1.25.3.linux-amd64.tar.gz ~/Downloads/software
rm -rf /usr/local/go && tar -C /usr/local -xzf ~/Downloads/software/go1.25.3.linux-amd64.tar.gz

## oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## oh-my-zsh-plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# TODO: add plugins to .zshrc

## powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# TODO: install fonts
# TODO: set theme in .zshrc

## alacritty (building from source)
### download
git clone https://github.com/alacritty/alacritty.git ~/code/prod/alacritty
cd code/prod/alacritty
### dependencies
apt-get install -y gcc fontconfig-devel
### build
cargo build --release
### desktop entry
cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
desktop-file-install extra/linux/Alacritty.desktop
update-desktop-database
