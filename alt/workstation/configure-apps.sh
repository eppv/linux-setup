# User apps configuration

HOSTNAME=$(hostname)
USER_NAME=$(id -nu 1000)
USER_HOME="/home/$USER_NAME"

## zsh
usermod root -s /bin/zsh
usermod $USER_NAME -s /bin/zsh

## Alacritty
mkdir $USER_HOME/.config/alacritty


# Переназначение Copilot (F23) на Right Control
echo -e "# Переназначение Copilot (F23) + блокировка \"мусорных\" клавиш Meta/Shift\nevdev:input:b0011v0001p0001*\n  KEYBOARD_KEY_db=!leftmeta     # Блокировка LeftMeta (Win)\n  KEYBOARD_KEY_2a=!leftshift    # Блокировка LeftShift\n  KEYBOARD_KEY_6e=rightctrl     # Переназначение F23 на RightCtrl" > /etc/udev/hwdb.d/99-copilot.hwdb
systemd-hwdb update
udevadm trigger

echo "Please reboot your system for changes to take effect."
