# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:18.04

MAINTAINER Dmitry Rodetsky "colirs.developer@gmail.com"
ENV REFRESHED_AT 2019-12-15

LABEL io.k8s.description="Headless VNC Container with IceWM window manager, chromium, android emulation" \
      io.k8s.display-name="Headless VNC Container based on Ubuntu 18.04" \
      io.openshift.expose-services="6901:http,5901:xvnc" \
      io.openshift.tags="vnc, ubuntu, icewm" \
      io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901 \
    NG_PORT=4200
EXPOSE $VNC_PORT $NO_VNC_PORT $NG_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    MY_EMAIL="myemail@email.com" \
    MY_NAME="My name" \
    NX_DIR_NAME=nxworkspace \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_USER=vncuser \
    VNC_PW=vncpass \
    VNC_VIEW_ONLY=false \
    ANDROID_HOME=/usr/local/android/sdk \
    ANDROID_VERSION=28 \
    ANDROID_ARCH="x86_64"
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

###Set timezone
COPY ./timezone /etc 

#Set up a non-root user
RUN $INST_SCRIPTS/setup_user.sh

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
#RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install IceWM UI
RUN $INST_SCRIPTS/icewm_ui.sh
ADD ./src/ubuntu/icewm/ $HOME/

### configure startup <Not needed any more as we use a real non-root user>
#RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

### android setup
ENV PATH=${PATH}:${ANDROID_HOME}tools/bin/ \
    PATH=${PATH}:${ANDROID_HOME}tools/:${ANDROID_HOME}platform-tools/
ADD ./src/tools ${ANDROID_HOME}/tools
RUN $INST_SCRIPTS/android_setup.sh

### install nx_workspace
RUN $INST_SCRIPTS/nx_install.sh

### Switch user to non-root user. This is necessary to avoid complications with android emulator --no-sandbox flag 
USER 1000

### Switch to home directory
WORKDIR $HOME

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]

#CMD tail -f /dev/null
#CMD ["su", "-", "${VNC_USER}", "-c", "/bin/bash"]