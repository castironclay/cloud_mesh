FROM bitnami/minideb:bullseye
ARG TERRAFORM=1.8.1
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"
COPY requirements.txt /root/requirements.txt
COPY providers.tf /root/providers.tf

RUN  echo "figlet BUILDER" >> /root/.bashrc && \
     echo "PS1='🏴‍☠️  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'" >> /root/.bashrc

RUN set -x && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get install -y -q dialog apt-utils && \
    apt-get install -y -q wget unzip python3 python3-pip figlet ssh jq vim rsync wireguard-tools && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    rm terraform_${TERRAFORM}_linux_amd64.zip && \
    pip install --upgrade pip && \
    pip install -r /root/requirements.txt && \
    mkdir -p /root/.terraform.d/plugin-cache && \
    apt-get clean

WORKDIR /root/
RUN terraform init && \
    rm -rf /root/providers.tf /root/requirements.txt

WORKDIR /work/cloud_mesh
    
