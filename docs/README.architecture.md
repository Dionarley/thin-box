# Thin Box – Architecture Overview

A **Thin Box Client for Real World Devices** é um thin client Linux moderno, projetado para operar em hardware real (PCs, thin clients dedicados e SBCs), com foco em **boot rápido**, **baixo consumo**, **imutabilidade**, **segurança** e **manutenibilidade**.

Este documento descreve a **arquitetura lógica** do sistema e o papel de cada camada.

---

## 🎯 Princípios de Design

* **Minimalismo**: apenas componentes essenciais no host
* **Imutabilidade**: sistema base read-only (overlay quando necessário)
* **Isolamento**: aplicações executadas em containers
* **Reprodutibilidade**: build previsível (Docker → QEMU → Hardware)
* **Hardware-agnostic**: compatível com PCs x86_64 e SBCs

---

## 🧱 Arquitetura em Camadas

```
┌─────────────────────────────┐
│        Hardware             │
│ (PC / Thin Client / SBC)    │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│   Linux Minimal (Host)      │
│  - Kernel custom            │
│  - systemd / OpenRC         │
│  - NetworkManager           │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│     Openbox (UI Layer)      │
│  - autostart.sh             │
│  - tint2 / polybar          │
│  - rofi / dmenu             │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│  Container Runtime Layer    │
│  ├─ Docker (apps)           │
│  └─ LXC (ambientes)         │
└──────────────┬──────────────┘
               │
┌──────────────▼──────────────┐
│   Containers Gráficos       │
│  - RDP client               │
│  - VNC client               │
│  - Chromium kiosk           │
│  - Apps internos            │
└─────────────────────────────┘
```

---

## 🖥️ Hardware Layer

Suporta:

* PCs x86_64 convencionais
* Thin clients dedicados
* SBCs (ex: Orange Pi, Raspberry Pi – conforme suporte de kernel)

Requisitos mínimos típicos:

* CPU x86_64 ou ARM64
* 1–2 GB RAM
* Boot UEFI (recomendado)
* Rede Ethernet ou Wi‑Fi

---

## 🧠 Linux Minimal (Host)

O host é responsável apenas por:

* Inicialização do sistema
* Gerenciamento de rede
* Execução da interface gráfica
* Execução do runtime de containers

Características:

* Kernel customizado (drivers essenciais apenas)
* Root filesystem **read-only**
* OverlayFS opcional para estado temporário
* Nenhuma aplicação de usuário instalada diretamente no host

---

## 🪟 Camada de Interface (Openbox)

O Openbox atua como **UI shell** do thin client:

* Extremamente leve
* Inicialização rápida
* Configuração simples via arquivos texto

Funções:

* Autostart do launcher
* Exibição de painel (tint2 / polybar)
* Interação mínima com o usuário

O usuário **não acessa um desktop tradicional**, apenas o necessário para iniciar sessões remotas ou aplicações.

---

## 📦 Container Runtime Layer

### Docker

Utilizado para:

* Aplicações gráficas isoladas
* Chromium em modo kiosk
* Clientes RDP / VNC / WebRTC

Benefícios:

* Atualizações simples
* Rollback rápido
* Host limpo

### LXC

Utilizado para:

* Ambientes mais completos
* Sessões persistentes
* Casos que exigem comportamento próximo a VM

---

## 🧩 Containers Gráficos

Cada aplicação do usuário roda em um container dedicado:

* FreeRDP
* TigerVNC / RealVNC
* Chromium (kiosk)
* Aplicações internas corporativas

Isso garante:

* Isolamento
* Segurança
* Facilidade de manutenção

---

## 🔐 Segurança

* Sistema base imutável
* Containers sem privilégios (quando possível)
* Superfície de ataque reduzida
* Possibilidade de Secure Boot (Limine)

---

## 🚀 Fluxo de Build e Teste

```
Docker (userspace)
   ↓
QEMU + Limine (boot real)
   ↓
ISO final / PXE
   ↓
Hardware físico
```

---

## 📌 Conclusão

A arquitetura do **Thin Box** separa claramente **host**, **interface** e **aplicações**, permitindo um thin client:

* Estável
* Seguro
* Fácil de atualizar
* Pronto para ambientes reais de produção

Este documento serve como referência técnica para desenvolvimento, troubleshooting e evolução do projeto.

