# Teste do Thin Client com QEMU + Limine Bootloader

Este documento descreve **como testar o Thin Client em uma máquina virtual QEMU**, utilizando o **Limine Bootloader**, validando finalmente o **fluxo real de boot** antes do deploy em hardware físico.

Este é o passo seguinte após a validação do userspace via Docker.

---

## 🎯 Objetivo

Validar em ambiente controlado:

* Limine Bootloader (UEFI)
* Kernel Linux real
* Initramfs
* Root filesystem minimal
* Integração com Openbox e launcher

Ou seja: **simular o thin client final**, sem depender ainda de hardware real.

---

## 🧱 Arquitetura do Teste

```
Host Linux
 └─ QEMU (UEFI)
     └─ Limine Bootloader
         └─ Kernel Linux
             └─ Initramfs
                 └─ RootFS
                     └─ Openbox
```

---

## 📦 Pré-requisitos no Host

Instale os pacotes necessários:

```bash
sudo apt install qemu-system-x86 ovmf mtools xorriso squashfs-tools
```

Verifique:

```bash
qemu-system-x86_64 --version
```

---

## 📁 Estrutura de Diretórios Recomendada

```
thin-client/
├── boot/
│   ├── vmlinuz-linux
│   ├── initramfs-linux.img
│   └── limine.cfg
├── limine/
│   └── limine-uefi-x86_64.efi
├── rootfs/
│   ├── bin/
│   ├── etc/
│   ├── usr/
│   └── ...
├── iso/
└── README.md
```

---

## 🔧 Obtendo o Limine

```bash
git clone https://github.com/limine-bootloader/limine.git
cd limine
make
```

Arquivo usado:

* `limine-uefi-x86_64.efi`

---

## ⚙️ Configuração do Limine (`limine.cfg`)

```ini
TIMEOUT=3
DEFAULT_ENTRY=ThinClient

:ThinClient
    PROTOCOL=linux
    KERNEL_PATH=boot:///vmlinuz-linux
    INITRD_PATH=boot:///initramfs-linux.img
    CMDLINE=root=/dev/ram0 rw quiet loglevel=3
```

> 💡 Para testes iniciais, o rootfs pode estar embutido no initramfs.

---

## 🧩 Criando um RootFS Básico (initramfs)

Exemplo mínimo usando BusyBox:

```bash
mkdir -p initramfs/{bin,sbin,etc,proc,sys,usr/bin}
cp /bin/busybox initramfs/bin/
cd initramfs
find . | cpio -H newc -ov > ../initramfs.img
```

> Posteriormente, substitua por rootfs real (Debian / Alpine / squashfs).

---

## 🖥️ UEFI com OVMF

O Limine funciona melhor em UEFI. Use OVMF:

Arquivos típicos:

* `/usr/share/OVMF/OVMF_CODE.fd`
* `/usr/share/OVMF/OVMF_VARS.fd`

---

## ▶️ Executando o QEMU

```bash
qemu-system-x86_64 \
  -machine q35 \
  -cpu host \
  -m 2048 \
  -enable-kvm \
  -bios /usr/share/OVMF/OVMF_CODE.fd \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd \
  -cdrom thin-client.iso \
  -boot d \
  -display gtk
```

---

## 📀 Criando uma ISO com Limine

Estrutura da ISO:

```
iso/
├── EFI/
│   └── limine/
│       └── limine-uefi-x86_64.efi
├── boot/
│   ├── vmlinuz-linux
│   ├── initramfs-linux.img
│   └── limine.cfg
```

Gerar ISO:

```bash
xorriso -as mkisofs \
  -efi-boot EFI/limine/limine-uefi-x86_64.efi \
  -efi-boot-part --efi-boot-image \
  -no-emul-boot \
  -o thin-client.iso iso/
```

---

## 🧪 O que Validar no Boot

* [ ] Limine aparece
* [ ] Kernel carrega
* [ ] Initramfs inicializa
* [ ] Shell ou Openbox inicia
* [ ] Sem kernel panic

---

## 🚨 Problemas Comuns

### Tela preta

* Kernel sem framebuffer
* Falta de `CONFIG_DRM`

### Kernel panic

* Root incorreto
* Initramfs ausente

### Limine não aparece

* Estrutura da ISO errada
* EFI mal configurado

---

## 🛣️ Próximos Passos

Após o boot funcionar:

1. Migrar rootfs para squashfs
2. OverlayFS (read-only)
3. Openbox autologin
4. Containers gráficos
5. PXE boot

---

## 📌 Conclusão

O uso de **QEMU + Limine** permite validar todo o caminho crítico do thin client com segurança e rapidez, reduzindo drasticamente erros no deploy final.

---

**Status:** Ambiente de boot em validação 🧪🚀
