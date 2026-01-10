## Visão Geral

Define o processo de boot do Thin Box usando Limine em modo UEFI.

## Componentes

* Limine UEFI
* Kernel Linux
* Initramfs custom
* Microcode Intel (opcional)

## Fluxo de Boot

```
UEFI
 → Limine
   → Kernel
     → initramfs
       → mount squashfs
       → mount overlayfs
       → switch_root
```

## Arquivos Importantes

* limine.cfg
* initramfs-linux.img
* intel-ucode.img