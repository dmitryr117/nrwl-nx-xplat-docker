#!/bin/bash
### every exit != 0 fails the script
set -e

### Install Node and npm
curl -sL https://deb.nodesource.com/setup_12.x | bash \
&& apt-get install -y git nodejs \
&& npm i -g npm \
&& git config --global user.email $MY_EMAIL \
&& git config --global user.name $MY_NAME \
&& npm install nativescript@6.3.0 -g --unsafe-perm \
&& mkdir $HOME/xplat \
&& cd $HOME/xplat && npx create-nx-workspace@8.9.0 $NX_DIR_NAME --preset="empty" --cli="nx" \
&& chmod -R 777 $HOME/xplat/$NX_DIR_NAME \
&& cd $HOME/xplat/$NX_DIR_NAME && npm install --save-dev @nstudio/xplat \
&& echo $PWD && cd $HOME \
&& chmod -R 755 $HOME/xplat \
&& mv $HOME/xplat $HOME/tmp \
&& chown -R 1000:root $HOME