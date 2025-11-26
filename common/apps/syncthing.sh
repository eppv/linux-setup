## syncthing
wget -O ~/Downloads/syncthing-linux-amd64-v2.0.11.tar.gz https://github.com/syncthing/syncthing/releases/download/v2.0.11/syncthing-linux-amd64-v2.0.11.tar.gz
tar -C '/opt' -xvf ~/Downloads/syncthing-linux-amd64-v2.0.11.tar.gz
mv /opt/syncthing-linux-amd64-v2.0.11 /opt/syncthing
mkdir -p ~/.config/systemd/user
curl -f https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/linux-systemd/user/syncthing.service > ~/.config/systemd/user/syncthing.service
## TODO: Change ExecStart=/opt/syncthing/syncthing --no-browser --no-restart --logflags=0
## TODO: Run from ordinary user: systemctl --user enable --now syncthing.service
