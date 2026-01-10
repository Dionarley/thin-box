#!/bin/bash
set -e

ROOTFS=src/rootfs
OUT=limine/rootfs.squashfs

echo "[thin-box] Building rootfs..."

# Limpa dirs runtime
mkdir -p $ROOTFS/{proc,sys,dev,var}

# Bootstrap base (executar uma vez ou quando quiser rebuild)
if [ ! -f "$ROOTFS/.bootstrapped" ]; then
  pacstrap -c $ROOTFS \
    base \
    linux-firmware \
    busybox \
    openbox \
    xorg-server \
    xorg-xinit \
    tint2 \
    chromium \
    networkmanager \
    sudo

  touch $ROOTFS/.bootstrapped
fi

# Configurações básicas
echo "thin-box" > $ROOTFS/etc/hostname

cat > $ROOTFS/etc/hosts <<EOF
127.0.0.1 localhost
127.0.1.1 thin-box
EOF

cat > $ROOTFS/etc/os-release <<EOF
NAME="Thin Box"
ID=thinbox
VERSION=0.1
EOF

# Ativa NetworkManager
ln -sf /usr/lib/systemd/system/NetworkManager.service \
  $ROOTFS/etc/systemd/system/multi-user.target.wants/NetworkManager.service

# Remove cache e lixo
rm -rf $ROOTFS/var/cache/pacman/pkg/*
rm -rf $ROOTFS/usr/share/man/*
rm -rf $ROOTFS/usr/share/doc/*

echo "[thin-box] Creating squashfs..."

mksquashfs $ROOTFS $OUT -comp zstd -Xcompression-level 15

echo "[thin-box] rootfs ready: $OUT"
