# Thin Client Linux com Limine Bootloader

Este projeto descreve a arquitetura, decisões técnicas e passos iniciais para a construção de um **Thin Client Linux moderno**, focado em **baixo consumo**, **boot rápido**, **alta segurança** e **execução de aplicações via containers**, utilizando **Limine Bootloader**, **Openbox**, **Docker** e **LXC**.

---

## 🎯 Objetivo

Construir um thin client capaz de:

* Inicializar rapidamente (boot mínimo)
* Operar com sistema imutável (read-only + overlay)
* Executar aplicações remotas e locais isoladas
* Utilizar containers para facilitar manutenção e atualização
* Servir como base para ambientes corporativos ou industriais

---

## 🧱 Stack Tecnológico

### Boot

* **Limine Bootloader** (UEFI / BIOS)
* Kernel Linux customizado
* Initramfs com Dracut ou mkinitcpio

### Sistema Base

* Debian minimal / Alpine Linux / Buildroot
* systemd ou OpenRC
* OverlayFS (opcional)

### Interface Gráfica

* Xorg
* **Openbox** (window manager)
* tint2 / polybar (opcional)
* rofi / dmenu (launcher)

### Containers

* **Docker** → aplicações isoladas
* **LXC / LXD** → ambientes persistentes

### Aplicações-alvo

* RDP (FreeRDP)
* VNC
* SPICE
* Chromium em modo kiosk (WebRTC / apps web)

---

## 🧠 Arquitetura Geral

```
UEFI / BIOS
   ↓
Limine Bootloader
   ↓
Linux Kernel
   ↓
initramfs
   ↓
Sistema Linux Minimal (read-only)
   ↓
Openbox
   ↓
Docker / LXC
   ↓
Aplicações Remotas
```

---

## 🚀 Por que Limine?

O **Limine Bootloader** foi escolhido em substituição ao GRUB por ser:

* Extremamente rápido
* Simples de configurar
* Ideal para sistemas imutáveis
* Compatível com UEFI e BIOS
* Melhor para kernels customizados

### Comparação

| Característica | GRUB  | Limine |
| -------------- | ----- | ------ |
| Complexidade   | Alta  | Baixa  |
| Velocidade     | Média | Alta   |
| Scripts        | Sim   | Não    |
| Thin Client    | ❌     | ✅      |

---

## 💽 Layout de Disco (UEFI recomendado)

```
/dev/sda
├─ sda1  EFI System Partition (FAT32)
│   └─ /EFI/limine/
│       ├─ limine-uefi-x86_64.efi
│       └─ limine.cfg
└─ sda2  Root filesystem (ext4 / squashfs)
```

---

## 🔧 Instalação do Limine

### Build

```bash
git clone https://github.com/limine-bootloader/limine.git
cd limine
make
```

### Instalação UEFI

```bash
mkdir -p /boot/EFI/limine
cp limine-uefi-x86_64.efi /boot/EFI/limine/
```

Criar entrada UEFI:

```bash
efibootmgr \
  --create \
  --disk /dev/sda \
  --part 1 \
  --loader '\\EFI\\limine\\limine-uefi-x86_64.efi' \
  --label 'Limine ThinClient'
```

---

## ⚙️ Configuração do Limine (`limine.cfg`)

```ini
TIMEOUT=3
DEFAULT_ENTRY=ThinClient

:ThinClient
    PROTOCOL=linux
    KERNEL_PATH=boot:///vmlinuz-linux
    INITRD_PATH=boot:///initramfs-linux.img
    CMDLINE=root=/dev/sda2 ro quiet loglevel=3
```

### Parâmetros úteis

* `quiet loglevel=3` → boot silencioso
* `mitigations=off` → boot mais rápido (avaliar segurança)
* `net.ifnames=0` → interfaces previsíveis

---

## 🧩 Sistema Imutável (Opcional)

Recomendado para thin clients:

* Root filesystem read-only
* OverlayFS em tmpfs

Exemplo de kernel cmdline:

```ini
CMDLINE=root=/dev/sda2 ro overlayroot=tmpfs
```

---

## 🖥️ Interface Gráfica com Openbox

### Estrutura

```
~/.config/openbox/
├── autostart
├── menu.xml
├── rc.xml
└── environment
```

### Exemplo de `autostart`

```sh
#!/bin/sh

setxkbmap br

# Painel
tint2 &

# Launcher principal
/usr/local/bin/thin-launcher &
```

---

## 📦 Docker para Aplicações Gráficas

Execução de apps isolados utilizando X11 do host:

```bash
docker run -d \
  --name rdp-client \
  --net=host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  rdp-client-image
```

Vantagens:

* Atualização simples
* Rollback fácil
* Host limpo

---

## 🧱 LXC para Ambientes Persistentes

Ideal para sessões completas:

* Firefox + LibreOffice
* Usuários dedicados

Exemplo:

```bash
lxc launch images:debian/12 thin-user1
```

---

## 🌐 Chromium em Modo Kiosk

```bash
chromium \
  --kiosk \
  --no-first-run \
  --disable-infobars \
  https://app.remoto.local
```

Pode rodar:

* Diretamente no host
* Dentro de Docker

---

## 🔐 Segurança

* Sistema read-only
* Containers sem privilégios
* Firewall no host
* Autologin sem shell
* Secure Boot (opcional)

---

## 🔄 Atualizações

* Pull automático de imagens Docker
* Configuração versionada em Git
* Reset por reboot

---

## 🛣️ Roadmap

### Fase 1 – Base

* [ ] Linux minimal
* [ ] Limine funcional
* [ ] Openbox + autologin

### Fase 2 – Containers

* [ ] Docker
* [ ] RDP / VNC / Web

### Fase 3 – Controle

* [x] Menu gráfico
* [x] Seleção de servidor
* [x] Autoconfig por MAC

### Fase 4 – Enterprise

* [ ] WireGuard
* [ ] USB-over-IP
* [ ] PXE Boot

---

## 📌 Próximos Passos

* Criar ISO bootável com Limine
* Kernel minimal custom
* PXE boot
* CI para build automático

---

**Status:** Em desenvolvimento 🚧
