import subprocess
from pathlib import Path
from typing import Optional, Tuple


def set_permissions(
        path: Path,
        permissions: str,
        owner: Optional[Tuple[str, str]] = None,
        sudo_password: Optional[str] = None
) -> bool:
    """
    Set file permissions and optionally change ownership.

    Args:
        path: Path to the file/directory
        permissions: Unix permissions string (e.g., '755')
        owner: Optional (user, group) tuple for ownership change
        sudo_password: Optional sudo password for privileged operations

    Returns:
        bool: True if all operations succeeded, False otherwise
    """
    try:
        # Convert permission string to octal
        permission_octal = int(permissions, 8)

        # Change ownership if requested
        if owner:
            if not sudo_password:
                print("Error: sudo_password required for ownership change")
                return False

            user, group = owner
            chown_cmd = ["sudo", "-S", "chown", f"{user}:{group}", str(path)]
            subprocess.run(
                chown_cmd,
                input=f"{sudo_password}\n".encode(),
                check=True,
                stderr=subprocess.PIPE
            )

        # Set permissions
        if owner or not sudo_password:
            path.chmod(permission_octal)
        else:
            chmod_cmd = ["sudo", "-S", "chmod", permissions, str(path)]
            subprocess.run(
                chmod_cmd,
                input=f"{sudo_password}\n".encode(),
                check=True,
                stderr=subprocess.PIPE
            )

        return True

    except (subprocess.CalledProcessError, ValueError, PermissionError) as e:
        print(f"Failed to set permissions: {e}")
        return False


