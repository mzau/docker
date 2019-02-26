#
# spinalhdl:dev Dockerfile
#
# parts from https://github.com/plex1/SpinalDev
#
# This file is based on spinalhdl:spinalhdl.
# It adds development tools as gtkwave and intellij w. scala plugin
#

FROM spinalhdl:yosysflow

# Global arguments
ARG USER=spinaldev
ARG USERPWD=spinaldev 
ARG WORKDIR=/home/spinaldev
ARG ROOTPWD=spinaldev

RUN apt-get update && apt-get install -y \
  wget \
  adwaita-icon-theme-full \ 
  emacs \
  unzip \
  x11-apps \
  xfce4\
  xrdp \ 
  xfce4-terminal 

###### tools #############################################
RUN apt-get install -y gtkwave

RUN mkdir -p $WORKDIR/projects/user

####### RICSV #############################################

## Make a working folder and set the necessary environment variables.
#ENV RISCV /opt/riscv
#ENV NUMJOBS 1
#
#
## Add the GNU utils bin folder to the path.
#ENV PATH $RISCV/bin:$PATH
#RUN echo 'export PATH=/opt/riscv/bin:$PATH' >> $WORKDIR/.bashrc
#
## Set the version variables
#ARG RISCV_GCC_VER=riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6
#
#WORKDIR /opt
#
## Download pre-built gcc compiler
#RUN wget https://static.dev.sifive.com/dev-tools/$RISCV_GCC_VER.tar.gz -q && \
#    tar -xzvf $RISCV_GCC_VER.tar.gz && \
#    mv $RISCV_GCC_VER /opt/riscv && \
#    rm $RISCV_GCC_VER.tar.gz
#
## Run a simple test to make sure compile is setup corretly
#RUN mkdir -p $RISCV/test
#WORKDIR $RISCV/test
#RUN echo '#include <stdio.h>\n int main(void) { printf("Hello \
#  world!\\n"); return 0; }' > hello.c 
#RUN riscv64-unknown-elf-gcc -o hello hello.c

USER $USER

####### IntelliJ #######################################

USER root

# Set the version variables
ARG INTELLIJ_VER=2018.3
ARG INTELLIJ_SUBVER=4
# version id can be found on jetbrains webpage when downloading of scala plugin
ARG INTELLIJ_VERID=47787

# Download and install intellij
RUN wget https://download.jetbrains.com/idea/ideaIC-$INTELLIJ_VER.$INTELLIJ_SUBVER.tar.gz -O /tmp/intellij.tar.gz -q && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz
RUN cd /opt/intellij/bin && \
    ln -s idea.sh intellij

# Add intellij to path
RUN echo 'export PATH=$PATH:/opt/intellij/bin/' >> $WORKDIR/.bashrc 

USER $USER

# Download and install intellij scala plugin

RUN mkdir -p $WORKDIR/.IdeaIC$INTELLIJ_VER/config/plugins && \
    wget https://plugins.jetbrains.com/plugin/download?updateId=$INTELLIJ_VERID -O $WORKDIR/.IdeaIC$INTELLIJ_VER/config/plugins/scalaplugin.zip -q && \    
    cd $WORKDIR/.IdeaIC$INTELLIJ_VER/config/plugins/ && \
    unzip -o -q scalaplugin.zip && \
    rm scalaplugin.zip

####### Startup Script ####################################

USER root
ENTRYPOINT ["/opt/startup.sh"]

