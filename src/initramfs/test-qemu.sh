qemu-system-x86_64 \
  -enable-kvm \
  -m 1024 \
  -cpu host \
  -drive if=virtio,file=disk.img \
  -bios OVMF.fd
