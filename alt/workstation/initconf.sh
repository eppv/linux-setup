
USERNAME=$(getent passwd 1000 | cut -d: -f1)
HOSTNAME=$(hostname)

# user sudo config
echo "$USERNAME $HOSTNAME=(ALL) ALL" >> /etc/sudoers.d/$USERNAME

# gsettings preset

## disable brightness autoadjustment
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

## center new windows, not maximize
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter auto-maximize false

## clock show date, 24h format
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-format 24h
