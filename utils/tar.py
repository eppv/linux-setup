import tarfile
import hashlib
import tempfile
import os
import json
import shutil
import logging
from pathlib import Path


SUPPORTED_EXT = ['.tar.gz', '.tar.bz2', '.tgz']

logger = logging.getLogger(__name__)


class ArchiveError(Exception):
    """Базовый класс ошибок архива"""


class InvalidArchiveError(ArchiveError):
    """Неподдерживаемый формат архива"""


class MissingManifestError(ArchiveError):
    """Отсутствует manifest.json"""


class ChecksumError(ArchiveError):
    """Несовпадение контрольных сумм"""


class SecurityError(ArchiveError):
    """Обнаружены потенциально опасные элементы"""


class ArchiveIntegrityError(ArchiveError):
    """Нарушена целостность архива"""


class Validator:
    @staticmethod
    def check_manifest(archive: tarfile.TarFile) -> bool:
        """Проверка наличия manifest.json в корне архива"""
        members = archive.getnames()
        return any(m == 'manifest.json' or m.startswith('manifest.json/') for m in members)

    @staticmethod
    def verify_checksums(temp_dir: Path, manifest: dict):
        """Сверка контрольных сумм SHA-256"""
        for rel_path, expected_hash in manifest.get('checksums', {}).items():
            file_path = temp_dir / rel_path
            if not file_path.exists():
                raise ChecksumError(f"Missing file for checksum verification: {rel_path}")

            with open(file_path, 'rb') as f:
                file_hash = hashlib.sha256(f.read()).hexdigest()

            if file_hash != expected_hash:
                raise ChecksumError(f"Checksum mismatch for {rel_path}")


class ArchiveHandler:
    def __init__(self, archive_path: str, temp_dir: str = None):
        self.archive_path = Path(archive_path)
        self.temp_dir = Path(temp_dir) if temp_dir else None
        self.manifest = None
        self.validator: Validator = Validator()
        self._validate_extension()
        self._temp_owner = False  # Флаг указывает, создавали ли мы директорию

    def _validate_extension(self):

        if not any(str(self.archive_path).endswith(ext) for ext in SUPPORTED_EXT):
            raise InvalidArchiveError(f"Unsupported archive format: {self.archive_path.suffix}")

    def cleanup(self):
        """Безопасное удаление временных файлов с проверками"""
        if not self.temp_dir or not self.temp_dir.exists():
            return

        try:
            # Дополнительные проверки безопасности
            if self._is_safe_to_delete():
                shutil.rmtree(self.temp_dir)
                logger.info(f"Cleaned temp directory: {self.temp_dir}")
                self.temp_dir = None
            else:
                logger.warning(f"Skipping deletion of unsafe path: {self.temp_dir}")
        except Exception as e:
            logger.error(f"Cleanup failed for {self.temp_dir}: {str(e)}")

    def _is_safe_to_delete(self) -> bool:
        """Проверка что путь является временной директорией"""
        temp_parents = [
            Path(tempfile.gettempdir()).resolve(),
            Path.cwd().resolve() / "tmp",
        ]

        return (
            # Директория была создана нами автоматически
                self._temp_owner

                # Или явно указанная директория находится в системной temp-директории
                or any(str(self.temp_dir).startswith(str(p)) for p in temp_parents)

                # И не содержит чувствительных путей
                and not any(s in str(self.temp_dir) for s in ("/etc", "/usr", "/var", "/bin"))
        )

    def extract(self) -> Path:
        """Безопасная распаковка с обработкой symlink и абсолютных путей"""
        if not self.temp_dir:
            self.temp_dir = Path(tempfile.mkdtemp(prefix="pkg_install_"))

        try:
            with tarfile.open(self.archive_path) as tar:
                # Первичная проверка структуры
                if not self.validator.check_manifest(tar):
                    raise MissingManifestError()

                # Фильтр безопасности для обработки членов архива
                safe_members = []
                for member in tar.getmembers():
                    if member.islnk() or member.issym():
                        raise SecurityError("Symlinks in archive are prohibited")
                    if not os.path.abspath(member.name).startswith(os.getcwd()):
                        member.name = os.path.relpath(member.name)
                    safe_members.append(member)

                tar.extractall(path=self.temp_dir, members=safe_members)

                # Загрузка и проверка манифеста
                manifest_path = self.temp_dir / 'manifest.json'
                with open(manifest_path) as f:
                    self.manifest = json.load(f)

                # Верификация контрольных сумм
                self.validator.verify_checksums(self.temp_dir, self.manifest)

                return self.temp_dir

        except (tarfile.TarError, json.JSONDecodeError) as e:
            self.cleanup()
            raise ArchiveIntegrityError(f"Archive processing failed: {str(e)}")
        finally:
            if self._temp_owner:
                self.cleanup()
