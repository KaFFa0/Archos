#!/bin/bash

LOG_DIR=$1 #../log
MAX_USAGE=$2
N=$3
BACKUP_DIR="./backup"

USAGE=$(df -h | awk 'NR==3 {print $5}' | sed 's/%//')
#echo $USAGE


if [ "$USAGE" -ge "$MAX_USAGE" ]; then
  TO_ARCH=$(find "$LOG_DIR" -type f -printf '%T@ %p\n' | sort -n | head -n "$N" | cut -d' ' -f2-)
else 
  echo "Enough space"
  exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCH_FILE="$BACKUP_DIR/archive_$TIMESTAMP.tar.gz"

tar -czf "$ARCH_FILE" $TO_ARCH
tar -tf "$ARCH_FILE"

echo "Удаление архивированных файлов..."
for file in $TO_ARCH; do
rm -f "$file"
done
