#!/bin/bash

HOSTNAME=$(hostname)
USER_NAME=$(id -nu 1000)

# Install applications
apt-get update &&

# basic apps with APT
echo "Installing basic apps with APT..."
apt-get install -y git alacritty telegram-desktop neofetch btop &&

# basic apps with Flatpak
flatpak install -y flathub md.obsidian.Obsidian

# HOME override!
HOME="/home/$USER_NAME"

# zed
sudo -E -u $USER_NAME bash -c 'echo "Installing Zed...to $HOME"'
sudo -E -u $USER_NAME bash -c 'curl -f https://zed.dev/install.sh | sh'
sudo -E -u $USER_NAME bash -c 'echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc'
sudo -E -u $USER_NAME bash -c 'echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.zshrc'


# User apps configuration

## zsh
usermod root -s /bin/zsh
usermod $USER_NAME -s /bin/zsh
ln -s /home/$USER_NAME/.zshrc /root/.zshrc

echo "Please reboot your system for changes to take effect."
