#!/bin/bash

# default args
DEFAULT_SOURCE="$HOME /etc"
DEFAULT_BACKUP="/mnt/backup/system"
DEFAULT_EXCLUDE_FILE=".backupignore"
DEFAULT_LOG_FILE="$HOME/backup.log"


resolve_path() {
  local path="$1"
  # Return if empty
  [ -z "$path" ] && return

  # Handle home directory shorthand
  if [[ "$path" = ~* ]]; then
    eval echo "$path"
    return
  fi

  # Convert relative to absolute path
  if [[ "$path" != /* ]]; then
    if [ -d "$path" ] || [ -f "$path" ]; then
      # If path exists relative to current directory
      echo "$(cd "$(dirname "$path")" || exit; pwd)/$(basename "$path")"
    else
      # Default to home directory
      echo "$HOME/$path"
    fi
  else
    # Already absolute path
    echo "$path"
  fi
}

log() {
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

resolve_source_dirs() {
  local source_dir="$1"
  local resolved_sources=""
  for dir in $source_dir; do
    resolved_dir=$(resolve_path "$dir")
    if [ ! -e "$resolved_dir" ]; then
      log "WARNING: Source directory does not exist - $resolved_dir"
      continue
    fi
    resolved_sources="$resolved_sources \"$resolved_dir\""
  done
  echo "$resolved_sources" | xargs # Clean up spaces
}


# argparse
while getopts "s:b:e:l:" opt; do
  case $opt in
    s) SOURCE_DIR="$OPTARG" ;;
    b) BACKUP_DIR="$OPTARG" ;;
    e) EXCLUDE_FILE="$OPTARG" ;;
    l) LOG_FILE="$OPTARG" ;;
    *) echo "Использование: $0"
       echo "   [-s исходные_каталоги]"
       echo "   [-b каталог_бэкапа]"
       echo "   [-e файл_исключений]"
       echo "   [-l лог_файл]"
       echo "Пример: $0 -s '/home /etc' -b '/mnt/backup' -e 'my_exclude.txt' -l 'backup_log.txt'"
       exit 1 ;;
  esac
done

# Применение значений по умолчанию, если аргументы не заданы
SOURCE_DIR="${SOURCE_DIR:-$DEFAULT_SOURCE}"
BACKUP_DIR="${BACKUP_DIR:-$DEFAULT_BACKUP}"
EXCLUDE_FILE="${EXCLUDE_FILE:-$DEFAULT_EXCLUDE_FILE}"
LOG_FILE="${LOG_FILE:-$DEFAULT_LOG_FILE}"


# Exclude file
if [ ! -f "$EXCLUDE_FILE" ]; then
  echo "Файл исключений не найден: $(resolve_path "$EXCLUDE_FILE")" >&2
  exit 1
fi


TEMP_EXCLUDE=$(mktemp)
grep -v '^#' "$EXCLUDE_FILE" | grep -v '^$' | while read -r line; do
  echo "$line"
done > "$TEMP_EXCLUDE"

# Make a backup directory
mkdir -p "$(resolve_path "$BACKUP_DIR")"

# Logging backup info
log "Start backup from '$(resolve_source_dirs "$SOURCE_DIR")' to '$(resolve_path "$BACKUP_DIR")'"

IFS=' ' read -ra SOURCE_DIRS <<< "$(resolve_source_dirs "$SOURCE_DIR")"

# Run rsync
 rsync -av --delete \
    --exclude-from="$TEMP_EXCLUDE" \
    "${SOURCE_DIRS[@]}" "$(resolve_path "$BACKUP_DIR")" >> "$LOG_FILE" 2>&1

# Check status
if [ $? -eq 0 ]; then
    log "Backup complete"
else
    log "Error while copying! Code: $?."
fi

# remove temp files
rm -f "$TEMP_EXCLUDE"
