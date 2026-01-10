# Teste do Thin Client em Docker

Este documento descreve **como testar o userspace do Thin Client utilizando Docker**, antes da validação final em VM ou hardware real com **Limine Bootloader**.

> ⚠️ **Importante:** o Docker **não executa bootloaders**. O objetivo aqui é validar **Openbox, launcher, aplicações gráficas e containers**, não o processo de boot.

---

## 🎯 Objetivo do Teste em Docker

Usar Docker como **ambiente de laboratório** para:

* Validar o userspace Linux
* Testar Openbox como interface gráfica
* Testar launcher do thin client
* Executar aplicações gráficas isoladas
* Simular Docker-in-Docker (apps do thin client)
* Reduzir ciclo de desenvolvimento antes do QEMU/ISO

---

## 🧱 O que é testado (e o que não é)

### ✅ Testável em Docker

* Openbox
* Xorg
* Chromium (modo normal ou kiosk)
* Docker dentro do thin client
* Fluxo de usuário único (`thin`)
* Scripts de inicialização

### ❌ Não testável em Docker

* Limine Bootloader
* Kernel custom
* Initramfs real
* Secure Boot
* PXE boot

Esses itens devem ser testados posteriormente em **QEMU ou hardware real**.

---

## 📦 Pré-requisitos no Host

* Linux com X11
* Docker instalado
* Permissão para rodar containers privilegiados

Verifique:

```bash
docker --version
```

---

## 🏗️ Build da Imagem

Na raiz do projeto:

```bash
docker build -t thinclient-test .
```

---

## ▶️ Execução do Container (com GUI)

Antes de executar, libere o acesso ao X11:

```bash
xhost +local:docker
```

Execute o container:

```bash
docker run -it --rm \
  --privileged \
  --net=host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --name thinclient \
  thinclient-test
```

### Por que essas opções?

* `--privileged` → necessário para systemd, Docker e LXC
* `--net=host` → facilita NetworkManager
* `/tmp/.X11-unix` → acesso gráfico
* `/sys/fs/cgroup` → systemd funcional

---

## 👤 Usuário Padrão

Dentro do container:

* Usuário: `thin`
* Sem senha
* sudo liberado

Trocar para o usuário:

```bash
su - thin
```

---

## 🖥️ Iniciando a Interface Gráfica

No container, como usuário `thin`:

```bash
startx
```

Você deverá ver:

* Openbox
* Painel (tint2)
* Launcher configurado no `autostart`

---

## 🚀 Thin Launcher

O launcher é iniciado automaticamente pelo Openbox:

```text
/usr/local/bin/thin-launcher
```

Exemplo simples:

* Menu via `rofi`
* Abertura de Chromium
* Execução de clientes RDP/VNC

---

## 🌐 Teste do Chromium

Dentro do ambiente gráfico:

```bash
chromium https://example.com
```

Ou modo kiosk:

```bash
chromium --kiosk https://example.com
```

---

## 📦 Docker Dentro do Thin Client

É possível testar containers gráficos como se fosse o ambiente final:

```bash
docker ps
docker run hello-world
```

Isso valida o modelo:

```
Thin Client
 └─ Docker
     └─ Aplicações
```

---

## 🧪 Checklist de Validação

* [ ] Container sobe com systemd
* [ ] Openbox inicia corretamente
* [ ] Launcher executa
* [ ] Chromium funciona
* [ ] Docker interno funcional

---

## 🧭 Próxima Etapa (fora do Docker)

Após validar o userspace:

1. Migrar rootfs para squashfs
2. Testar boot em QEMU
3. Integrar Limine Bootloader
4. Gerar ISO final

---

## 📌 Observações Finais

* Docker **acelera o desenvolvimento**, mas não substitui testes reais
* Qualquer bug resolvido aqui reduz drasticamente problemas no boot final

---

**Status:** Ambiente de teste funcional 🧪
