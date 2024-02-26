#!/usr/bin/env bash
umask 077
wg genkey | tee client_privatekey | wg pubkey > client_publickey
wg genkey | tee server_privatekey | wg pubkey > server_publickey