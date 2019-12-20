#!/bin/bash

DIRPATH="${PWD}/xplat"
echo $DIRPATH
PREPDONE=0

#create folder nxworkspace and set its owner
if [ "$1" == "up" ]; then
  if [ "$2" == "-d" ]; then
    echo "Starting Up"
    if [ ! -d $DIRPATH ]; then
      echo "Create directory"
      mkdir $DIRPATH \
      && chown -R 1000:root $PWD
      if [ $? -eq 0 ]; then
        PREPDONE=1
      else
        echo "Error setting permissions. Removing workspace"
        rm -r $DIRPATH
      fi
    else
      PREPDONE=1
    fi
    if [ $PREPDONE == 1 ]; then
      echo "Starting container"
      docker-compose up -d
    fi
  else
    echo "Use up -d flag"
  fi
fi

if [ "$1" == "down" ]; then
  echo "Shutting Down"
  docker-compose down
fi

if [ "$1" == "reset" ]; then
  echo "Removing workspace directory"
  rm -rf $DIRPATH
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Available flags:"
  echo "reset       --- Reset projects directory"
  echo "up -d       --- Start up the container"
  echo "down        --- Shut down and remove container. This does not remove container image"
fi

if [ "$1" == "" ]; then
  echo "Flags are required"
fi