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
