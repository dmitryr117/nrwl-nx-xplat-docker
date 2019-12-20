#! /usr/bin/env bash
### every exit != 0 fails the script
set -e

useradd $VNC_USER -d $HOME -u 1000 -s /bin/bash
yes $VNC_PW | passwd $VNC_USER
usermod -a -G sudo $VNC_USER
usermod -a -G adm $VNC_USER
