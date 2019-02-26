#
# spinalhdl:dev Dockerfile
#
# parts from https://github.com/plex1/SpinalDev
#
# This file is based on spinalhdl:spinalhdl.
# It adds development tools as RISC-V compiler, gtkwave and indelij
#

FROM spinalhdl:spinalhdl

# Global arguments
ARG USER=spinaldev
ARG USERPWD=spinaldev 
ARG WORKDIR=/home/spinaldev
ARG ROOTPWD=spinaldev

RUN apt-get update && apt-get install -y \
  sudo \
  adwaita-icon-theme-full \ 
  emacs \
  git \
  x11-apps \
  xfce4\
  xrdp \ 
  xfce4-terminal 

####### Linux ##########################################

# Change root password
RUN echo "root:${ROOTPWD}" | chpasswd

# Create the default user
RUN useradd -m -s /bin/bash -d ${WORKDIR} ${USER}
RUN echo "${USER}:${USERPWD}" | chpasswd
RUN adduser ${USER} sudo

# Customize terminal
RUN echo 'RESET="\[$(tput sgr0)\]"' >> $WORKDIR/.bashrc
RUN echo 'GREEN="\[$(tput setaf 2)\]"' >> $WORKDIR/.bashrc 
RUN echo 'export PS1="${GREEN}\u:\W${RESET} $ "' >> $WORKDIR/.bashrc 

# owner settings:
#  - user root for all files in /opt
#  - user spinaldev for all files in /home/spinaldev

USER root

###### tools #############################################
RUN apt-get install -y gtkwave

RUN mkdir -p $WORKDIR/projects/user

####### RICSV #############################################

# Make a working folder and set the necessary environment variables.
ENV RISCV /opt/riscv
ENV NUMJOBS 1


# Add the GNU utils bin folder to the path.
ENV PATH $RISCV/bin:$PATH
RUN echo 'export PATH=/opt/riscv/bin:$PATH' >> $WORKDIR/.bashrc

# Set the version variables
ARG RISCV_GCC_VER=riscv64-unknown-elf-gcc-20170612-x86_64-linux-centos6

WORKDIR /opt

# Download pre-built gcc compiler
RUN wget https://static.dev.sifive.com/dev-tools/$RISCV_GCC_VER.tar.gz -q && \
    tar -xzvf $RISCV_GCC_VER.tar.gz && \
    mv $RISCV_GCC_VER /opt/riscv && \
    rm $RISCV_GCC_VER.tar.gz

# Run a simple test to make sure compile is setup corretly
RUN mkdir -p $RISCV/test
WORKDIR $RISCV/test
RUN echo '#include <stdio.h>\n int main(void) { printf("Hello \
  world!\\n"); return 0; }' > hello.c 
RUN riscv64-unknown-elf-gcc -o hello hello.c

USER $USER
