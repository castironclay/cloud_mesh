# Setup SOCKS proxy
ssh -D 12345 -C -N -i id_ssh_rsa1 root@172.104.189.39

# U
ssh -D localhost:8087 -S /tmp/.ssh-aws-gateway-vpc1 -M -fN aws-gateway-vpc1
# (...)
# later, when you want to terminate ssh connection
ssh -S /tmp/.ssh-aws-gateway-vpc1 -O exit aws-gateway-vpc1
