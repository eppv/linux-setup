import subprocess
from pathlib import Path


def extract_appimage(appimage_path: Path, extract_dir: Path) -> None:
    """Extract AppImage to specified directory."""
    try:
        print(f"Extracting {appimage_path.name}...")
        subprocess.run(
            [str(appimage_path), "--appimage-extract"],
            cwd=extract_dir,
            check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Extraction failed: {e}")
        exit(1)
