HOSTNAME=$(hostname)
USER_NAME=$(id -nu 1000)

# gsettings preset

## disable brightness autoadjustment
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

## center new windows, not maximize
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter auto-maximize false

## clock show date, 24h format
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-format 24h

mkdir -p ${HOME}/code/{dev,prod}
mkdir -p ${HOME}/data/access
echo "*.gpg" >> ${HOME}/data/access/.stignore
mkdir -p ${HOME}/backup
