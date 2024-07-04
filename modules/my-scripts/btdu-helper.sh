#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

mkdir -p /enc

mount -o subvol=/ /dev/mapper/enc /enc

btdu /enc

sleep .5

umount /enc
