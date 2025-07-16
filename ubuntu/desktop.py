
import subprocess
import shutil
from pathlib import Path


def create_desktop_entry(
    entry_path: Path,
    app_name: str,
    app_exec: Path,
    icon_path: Path,
    version: str
) -> None:
    """Create desktop entry file."""
    try:
        print(f"Creating desktop entry at {entry_path}...")
        entry_content = f"""[Desktop Entry]
Version={version}
Name={app_name}
Comment=Run {app_name}
Exec={app_exec}
Icon={icon_path}
Terminal=false
Type=Application
Categories=Utility;Application;
StartupWMClass={app_name}
"""
        entry_path.parent.mkdir(parents=True, exist_ok=True)
        with open(entry_path, 'w') as f:
            f.write(entry_content)
        entry_path.chmod(0o755)
    except OSError as e:
        print(f"Failed to create desktop entry: {e}")
        exit(1)


def update_desktop_database(applications_dir: Path) -> None:
    """Update desktop database."""
    try:
        print("Updating desktop database...")
        subprocess.run(
            ["update-desktop-database", str(applications_dir)],
            check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Failed to update desktop database: {e}")
        exit(1)


def copy_icon(source: Path, destination: Path) -> None:
    """Copy application icon to target location."""
    try:
        print(f"Copying icon to {destination}...")
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(str(source), str(destination))
    except (OSError, shutil.SameFileError) as e:
        print(f"Failed to copy icon: {e}")
        exit(1)

