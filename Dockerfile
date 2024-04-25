FROM bitnami/minideb:bullseye
ARG TERRAFORM=1.8.1
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"
COPY requirements.txt /root/requirements.txt
COPY providers.tf /root/providers.tf
COPY sr/ /root/sr
WORKDIR /root/

RUN  echo "figlet BUILDER" >> /root/.bashrc && \
     echo "PS1='🏴‍☠️  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'" >> /root/.bashrc

RUN set -x && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q dialog apt-utils && \
    apt-get install -y -q wget unzip python3 python3-pip figlet ssh jq vim rsync wireguard-tools iproute2 curl

# Terraform setup
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    rm terraform_${TERRAFORM}_linux_amd64.zip && \
    mkdir -p /root/.terraform.d/plugin-cache

# Python packages
RUN pip install --upgrade pip && \
    pip install -r /root/requirements.txt && \
    apt-get clean

# WGCF setup
RUN wget -q https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_386 && \
    chmod +x wgcf_2.2.22_linux_386 &&\
    mv wgcf_2.2.22_linux_386 /usr/local/bin/wgcf && \
    wgcf register --accept-tos && \
    wgcf generate
    
RUN terraform init && \
    rm -rf /root/providers.tf /root/requirements.txt

WORKDIR /work/sr
    
