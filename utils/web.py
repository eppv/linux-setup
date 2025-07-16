import urllib.request
import urllib.error
from pathlib import Path
import time


def download_file(
        url: str,
        destination: Path,
        timeout: int = 30,
        retries: int = 3,
        chunk_size: int = 8192,
        user_agent: str = "Mozilla/5.0 (X11; Linux x86_64) Python-urllib"
) -> bool:
    """
    Download a file from a URL to the specified destination using pure Python.

    Args:
        url: Source URL to download from
        destination: Target path to save the file
        timeout: Connection timeout in seconds
        retries: Number of retry attempts
        chunk_size: Bytes to read at a time
        user_agent: User-Agent header to send

    Returns:
        bool: True if download succeeded, False otherwise
    """
    headers = {"User-Agent": user_agent}
    request = urllib.request.Request(url, headers=headers)

    for attempt in range(1, retries + 1):
        try:
            print(f"Downloading {url} (attempt {attempt}/{retries})...")
            start_time = time.time()

            with urllib.request.urlopen(request, timeout=timeout) as response:
                # Check if we got a successful response
                if response.status != 200:
                    print(f"Server returned status code {response.status}")
                    continue

                # Get file size if available (for progress reporting)
                file_size = int(response.headers.get('Content-Length', 0))
                downloaded = 0

                # Ensure destination directory exists
                destination.parent.mkdir(parents=True, exist_ok=True)

                # Download the file in chunks
                with open(destination, 'wb') as f:
                    while True:
                        chunk = response.read(chunk_size)
                        if not chunk:
                            break
                        f.write(chunk)
                        downloaded += len(chunk)

                        # Optional: Print progress if we know the total size
                        if file_size > 0:
                            percent = (downloaded / file_size) * 100
                            print(f"\rProgress: {percent:.1f}%", end='')

                # Print final newline if we showed progress
                if file_size > 0:
                    print()

                download_time = time.time() - start_time
                print(f"Download completed in {download_time:.1f} seconds")
                return True

        except urllib.error.URLError as e:
            print(f"Download error: {e.reason}")
            if attempt < retries:
                print(f"Retrying in {attempt} seconds...")
                time.sleep(attempt)  # Exponential backoff would be better
        except IOError as e:
            print(f"File system error: {e}")
            return False
        except Exception as e:
            print(f"Unexpected error: {e}")
            if attempt >= retries:
                break
            time.sleep(1)

    print(f"Failed to download after {retries} attempts")
    return False
