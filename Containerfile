FROM registry.fedoraproject.org/fedora:latest

RUN dnf install -y flatpak && \
    dnf clean all

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

COPY ghcurl /usr/bin/ghcurl
COPY build.sh /tmp/build.sh

RUN chmod +x /tmp/build.sh && /tmp/build.sh
