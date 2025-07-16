
import getpass
import subprocess


def get_sudo_password() -> str:
    """Prompt for and validate sudo password."""
    print("This script should be run with superuser privileges.")
    password = getpass.getpass("Enter your sudo password: ")

    try:
        subprocess.run(
            ['sudo', '-S', 'true'],
            input=password.encode(),
            check=True,
            stderr=subprocess.DEVNULL
        )
        return password
    except subprocess.CalledProcessError:
        print("Incorrect password. Exiting.")
        exit(1)