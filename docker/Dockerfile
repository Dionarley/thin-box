# ===============================
# Thin Client - Ambiente de Teste
# Baseado em Debian para validação
# ===============================

FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------
# Dependências básicas
# -------------------------------
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    dbus \
    sudo \
    xorg \
    openbox \
    tint2 \
    rofi \
    chromium \
    docker.io \
    lxc \
    lxd \
    network-manager \
    x11-xserver-utils \
    git \
    curl \
    vim \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Usuário thin
# -------------------------------
RUN useradd -m -s /bin/bash thin && \
    echo "thin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# -------------------------------
# Openbox config
# -------------------------------
RUN mkdir -p /home/thin/.config/openbox

COPY openbox/autostart /home/thin/.config/openbox/autostart
RUN chmod +x /home/thin/.config/openbox/autostart && \
    chown -R thin:thin /home/thin/.config

# -------------------------------
# Thin launcher
# -------------------------------
COPY thin-launcher.sh /usr/local/bin/thin-launcher
RUN chmod +x /usr/local/bin/thin-launcher

# -------------------------------
# Enable systemd services
# -------------------------------
RUN systemctl enable NetworkManager || true

# -------------------------------
# Systemd container requirements
# -------------------------------
VOLUME ["/sys/fs/cgroup"]
STOPSIGNAL SIGRTMIN+3

# -------------------------------
# Default target
# -------------------------------
CMD ["/sbin/init"]
