#!/usr/bin/env python3
from pathlib import Path
from utils.shell import set_permissions
from utils.security import get_sudo_password
from utils.appimage import extract_appimage
from ubuntu.desktop import (
    copy_icon,
    create_desktop_entry,
    update_desktop_database
)

APP_NAME = 'Cursor'
DEFAULT_VERSION = '0.48'


def install_appimage(
    app_image: str,
    app_dir: str = Path.home() / "apps/",
    app_icon_name: str = "code",
    ask_sudo: bool = True
) -> bool:
    # Main installation logic

    print(app_image)
    print(app_dir)

    app_name_lower = APP_NAME.lower()
    app_image_path = Path(app_image)
    app_dir_path = Path(app_dir)
    try:

        sudo_password = get_sudo_password() if ask_sudo else None

        if not set_permissions(app_image_path, "755"):
            print("Warning: Failed to set executable permissions")

        extract_appimage(app_image_path, app_dir_path)
        chrome_sandbox = app_dir_path / "squashfs-root/usr/share/cursor/chrome-sandbox"
        app_exec = app_dir_path / "squashfs-root/AppRun"
        app_icon_source = app_dir_path / f"squashfs-root/{app_icon_name}.png"
        app_icon_target = Path.home() / f".local/share/icons/{APP_NAME}-icon.png"
        desktop_entry_path = Path.home() / f".local/share/applications/{app_name_lower}.desktop"

        # 5. Handle sandbox permissions if exists
        if chrome_sandbox.exists() and sudo_password:
            set_permissions(
                chrome_sandbox,
                "4755",
                owner=("root", "root"),
                sudo_password=sudo_password
            )

        app_image_path.unlink()  # Remove downloaded AppImage
        copy_icon(app_icon_source, app_icon_target)
        create_desktop_entry(
            desktop_entry_path,
            APP_NAME,
            app_exec,
            app_icon_target,
            DEFAULT_VERSION
        )

        update_desktop_database(desktop_entry_path.parent)

        return True

    except Exception as e:
        print(f"Installation failed: {e}")
        return False


if __name__ == '__main__':

    appimage_path = r'/home/eppv/apps/cursor/Cursor-0.48.6-x86_64.AppImage'
    appdir_path = (Path.home() / "apps" / "cursor").__str__()
    install_appimage(appimage_path, appdir_path)
