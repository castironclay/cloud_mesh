#!/bin/bash
# Create local keys
# Push public key and add peer
scp -i id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=./known_hosts-{{ projectname }} clientpublickey {{ username }}@{{ hostvars['hop0'].ansible_host }}:~
ssh -i id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=./known_hosts-{{ projectname }} {{ username }}@{{ hostvars['hop0'].ansible_host }} 'export CLIENTPUB="$(cat ~/clientpublickey)"; sudo ip netns exec wireguard wg set wg3 peer $CLIENTPUB allowed-ips 10.3.1.2/32; sudo ip netns exec wireguard wg'
export SERVERPUB="$(cat server_pubkey)"
sudo wg-quick up ./wg3-client.conf
