#!/bin/sh
set -e

ROOT="$(pwd)/src/initramfs"
OUT="limine/initramfs-linux.img"

cd "$ROOT"

find . | cpio -H newc -o | gzip -9 > "../../$OUT"

echo "[thin-box] initramfs built: $OUT"
