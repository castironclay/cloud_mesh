#!/usr/bin/env bash

set -e


_downwgcf() {
  echo
  echo "clean up"
  if ! wg-quick down wgcf; then
    echo "error down"
  fi
  echo "clean up done"
  exit 0
}



#-4|-6
runwgcf() {
  trap '_downwgcf' ERR TERM INT

  _enableV4="1"
  if [ "$1" = "-6" ]; then
    _enableV4=""
  fi


  if [ ! -e "wgcf-account.toml" ]; then
    wgcf register --accept-tos
  fi

  if [ ! -e "wgcf-profile.conf" ]; then
    wgcf generate
  fi
  
  cp wgcf-profile.conf /etc/wireguard/wgcf.conf

  sed -i 's/AllowedIPs = ::/#AllowedIPs = ::/' /etc/wireguard/wgcf.conf
  sed -i 's/DNS = /#DNS = /' /etc/wireguard/wgcf.conf
  sed -i '/^Address = \([0-9a-fA-F]\{1,4\}:\)\{7\}[0-9a-fA-F]\{1,4\}\/[0-9]\{1,3\}/s/^/#/' /etc/wireguard/wgcf.conf
  wg-quick up wgcf
  echo 'nameserver 1.1.1.1' > /etc/resolv.conf
  
  _checkV4

  echo 
  echo "OK, wgcf is up."
  
  /bin/bash
  #sleep infinity & wait
  
  
}

_checkV4() {
  echo "Checking network status, please wait...."
  while ! curl --max-time 5  https://ipinfo.io; do
    wg-quick down wgcf
    echo "Sleep 5 and retry again."
    sleep 5
    wg-quick up wgcf
  done


}

if [ -z "$@" ] || [[ "$1" = -* ]]; then
  runwgcf "$@"
else
  exec "$@"
fi


