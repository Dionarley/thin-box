## Visão Geral

Processo de build das imagens do sistema Thin Box.

## Etapas

1. Build do rootfs base
2. Compressão SquashFS
3. Geração do initramfs
4. Configuração do Limine
5. Geração de ISO / imagem de disco

## Ferramentas

* pacstrap / debootstrap
* mksquashfs
* busybox
* limine