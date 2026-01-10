# Thin Box — Documentation Set

> Minimal Secure Thin Client Platform for Real World Devices

Este documento contém **todos os READMEs padronizados** do projeto Thin Box.
Cada seção abaixo corresponde diretamente a um arquivo `README*.md` no repositório.

---

# README.md

## Visão Geral

**Thin Box** é uma plataforma de *thin client* Linux minimalista, segura e imutável, projetada para hardware real (PCs, thin clients x86_64 e SBCs). O sistema utiliza boot UEFI com **Limine**, root filesystem imutável e execução de aplicações gráficas isoladas via containers.

## Objetivos

* Boot rápido e previsível
* Sistema imutável com rollback simples
* Execução de aplicações gráficas isoladas
* Manutenção e atualização centralizada
* Baixo custo operacional

## Stack Principal

* Bootloader: **Limine (UEFI)**
* Kernel Linux custom
* RootFS: **SquashFS + OverlayFS**
* UI: **Openbox**
* Containers: **Docker / LXC**
* Testes: **QEMU**

## Quick Start (QEMU)

```bash
./scripts/run-in-qemu.sh
```

## Documentação

* README.architecture.md
* README.boot.md
* README.build.md
* README.runtime.md
* README.security.md
* README.qemu.md
* README.docker.md
* README.lxc.md

## Status do Projeto

Em desenvolvimento ativo — foco atual em rootfs imutável e pipeline de boot.

---

# README.architecture.md

## Visão Geral

Este documento descreve a arquitetura de alto nível do Thin Box e o fluxo completo do sistema, do boot ao runtime gráfico.

## Arquitetura Geral

```
Hardware
  ↓
UEFI + Limine
  ↓
Kernel Linux
  ↓
Initramfs
  ↓
SquashFS (RO) + OverlayFS (RW)
  ↓
Systemd
  ↓
Openbox
  ↓
Containers Gráficos
```

## Camadas

* **Boot**: Limine UEFI
* **Sistema Base**: Kernel + initramfs
* **Userland**: RootFS imutável
* **UI**: Openbox
* **Runtime**: Docker / LXC

## Princípios

* Imutabilidade
* Isolamento
* Simplicidade operacional

---

# README.boot.md

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

---

# README.build.md

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

---

# README.runtime.md

## Visão Geral

Define o ambiente de execução do Thin Box após o boot.

## UI

* Openbox
* Autostart controlado
* Kiosk mode opcional

## Containers

* Chromium Kiosk
* Clientes RDP / VNC
* Aplicações internas

## Fluxo

```
Boot
 → Login automático
   → Openbox
     → Container gráfico
```

---

# README.security.md

## Visão Geral

Diretrizes de segurança e isolamento do Thin Box.

## Estratégias

* RootFS imutável
* Containers isolados
* Sem acesso root ao usuário
* Firewall básico

## Futuro

* Secure Boot
* TPM
* Atualizações assinadas

---

# README.qemu.md

## Visão Geral

Execução e testes do Thin Box usando QEMU.

## Requisitos

* qemu-system-x86_64
* OVMF (UEFI)

## Execução

```bash
./scripts/run-in-qemu.sh
```

## Objetivo

Validar boot, initramfs e rootfs antes do hardware real.

---

# README.docker.md

## Visão Geral

Ambiente Docker para desenvolvimento e testes do userland.

## Objetivo

Permitir iteração rápida sem reboot.

## Uso

```bash
./scripts/run-in-docker.sh
```

---

# README.lxc.md

## Visão Geral

Uso de LXC como alternativa leve ao Docker.

## Casos de Uso

* Containers gráficos
* Menor overhead

## Execução

```bash
./scripts/run-in-lxc.sh
```

---

## Próximos Passos

* Implementar rootfs SquashFS + OverlayFS
* Initramfs mínimo funcional
* Atualização atômica
