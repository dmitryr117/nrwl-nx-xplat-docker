# Dockerized Nstudio Xplat with Android emulator

## Intro

When setting up a developer environment - I ran into a issue with things not quite working right away out of the box. There are a lot of steps to follow, and often times developers have to spend countless hours setting up a development environment before having any chance of writing any actual project code.

I ran into the same issue when setting up my development environment. After I got it to work - I decided to make this project here so that development environment can be installed easily using Docker. Now this way I can set up a development environment with needed packages and an Android emulator just by pulling a docker image and running it.

## How to use it

#### Dist directories:

 /dist - contains code to start up and run pre-build images.

Every distribution has a startup.sh file which is used to start and stop and remove a container

#### Development root:

/ - root directory contains:
 
Dockerfile - Used for building a new image
 
docker-compose.yml - flag configuration of docker image
 
/src - this folder contains shell scripts required for image build
 
/startup.sh - this shell script is used to build, rebuild, start and stop a container. You can see commands available by typing: `./startup.sh -h`


Pre-built docker versions of @nstudio/xplat development environment with android emulators
