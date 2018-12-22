# KeePassXC Linux Release Build Dockerfile
# Copyright (C) 2017-2018 KeePassXC team <https://keepassxc.org/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 or (at your option)
# version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM ubuntu:18.04

ENV REBUILD_COUNTER=10

ENV QT5_VERSION=qt511
ENV QT5_PPA_VERSION=qt-5.11.2
ENV TERM=xterm-256color

RUN set -x \
    && apt-get update -y \
    && apt-get -y install software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && add-apt-repository ppa:beineri/opt-${QT5_PPA_VERSION}-bionic \
    && add-apt-repository ppa:phoerious/keepassxc
RUN set -x \
    && apt-get update -y \
    && apt-get upgrade -y

# build and runtime dependencies
RUN set -x \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y \
        cmake \
        curl \
        g++ \
        git \
        libargon2-0-dev \
        libcurl4-gnutls-dev \
        libgcrypt20-dev \
        libfuse2 \
        libqrencode-dev \
        libsodium-dev \
        libxi-dev \
        libxtst-dev \
        libyubikey-dev \
        libykpers-1-dev \
        mesa-common-dev \
        xclip \
        xvfb \
        zlib1g-dev \
        ${QT5_VERSION}base \
        ${QT5_VERSION}tools \
        ${QT5_VERSION}x11extras \
        ${QT5_VERSION}translations \
        ${QT5_VERSION}imageformats \
        ${QT5_VERSION}svg \
    && apt-get autoremove --purge \
    && rm -rf /var/lib/apt/lists/*


RUN set -x \
    && echo "/opt/${QT5_VERSION}/lib" > /etc/ld.so.conf.d/${QT5_VERSION}.conf \
    && echo "/opt/keepassxc-libs/lib/x86_64-linux-gnu" > /etc/ld.so.conf.d/keepassxc.conf

ARG SGX_SDK_INSTALL_DIR="/opt/intel/sgxsdk"
ARG SGX_SDK_VERSION="2.4"
ARG SGX_SDK_BIN="sgx_linux_x64_sdk_2.4.100.48163.bin"

RUN set -x \
    && curl -SLO "https://download.01.org/intel-sgx/linux-${SGX_SDK_VERSION}/ubuntu18.04-server/${SGX_SDK_BIN}" \
    && chmod +x ${SGX_SDK_BIN} \
    && mkdir -p $(dirname ${SGX_SDK_INSTALL_DIR}) \
    && ./${SGX_SDK_BIN} --prefix=$(dirname ${SGX_SDK_INSTALL_DIR}) \
    && rm -rf ${SGX_SDK_BIN}

ENV PATH="/opt/${QT5_VERSION}/bin:${SGX_SDK_INSTALL_DIR}/bin:${PATH}"
ENV CMAKE_PREFIX_PATH="/opt/${QT5_VERSION}/lib/cmake"
ENV CMAKE_INCLUDE_PATH="/opt/keepassxc-libs/include:${SGX_SDK_INSTALL_DIR}/include"
ENV CMAKE_LIBRARY_PATH="/opt/keepassxc-libs/lib/x86_64-linux-gnu:${SGX_SDK_INSTALL_DIR}/lib64"
ENV CPATH="${CMAKE_INCLUDE_PATH}"
ENV LD_LIBRARY_PATH="${CMAKE_LIBRARY_PATH}:/opt/${QT5_VERSION}/lib:${SGX_SDK_INSTALL_DIR}/lib64"

RUN set -x \
    && curl -L "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage" > /usr/bin/linuxdeploy \
    && curl -L "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage" > /usr/bin/linuxdeploy-plugin-qt \
    && curl -L "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" > /usr/bin/appimagetool \
    && chmod +x /usr/bin/linuxdeploy \
    && chmod +x /usr/bin/linuxdeploy-plugin-qt \
    && chmod +x /usr/bin/appimagetool

VOLUME /keepassxc/src
VOLUME /keepassxc/out
WORKDIR /keepassxc
