# This Dockerfile adds the FPGA workflow to spinalhdl:spinalhdl
#
#  Overview of added tools
#  From github.com:
#    SpinalHDL/openocd_risc
#    YosysHQ/yosys
#    cliffordwolf/icestorm
#    YosysHQ/arachne-pnr
#
#  also a user spinaldev, password spinaldev is added
#


FROM spinalhdl:spinalhdl

# Global arguments
ARG USER=spinaldev
ARG USERPWD=spinaldev 
ARG WORKDIR=/home/spinaldev
ARG ROOTPWD=spinaldev

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

RUN apt-get update && apt-get install -y \
  sudo \
  nano \
  vim

####### FPGA/ASIC FLOW ####################################

WORKDIR /opt

#openocd-riscv-vecriscv
RUN apt-get install -y \
  libtool automake libusb-1.0.0-dev texinfo libusb-dev libyaml-dev pkg-config
  
RUN git clone https://github.com/SpinalHDL/openocd_riscv.git && \
    cd openocd_riscv && \
    ./bootstrap && \
    ./configure --enable-ftdi --enable-dummy  && \
    make
    
#icepack see http://www.clifford.at/icestorm/   
#icepack dependencies
RUN apt-get install -y \
  pkg-config \
  libftdi-dev \
  libffi-dev
  
#yosys dependencies  
RUN apt-get install -y \
  bison flex \
  tcl-dev \
  clang\
  gawk \
  libreadline-dev \
  mercurial 
  
# yosys  
RUN git clone https://github.com/YosysHQ/yosys.git yosys && \
    cd yosys && \
    make -j$(nproc) && \
    make install
    
# icepack
RUN git clone https://github.com/cliffordwolf/icestorm.git icestorm && \
    cd icestorm && \
    make -j$(nproc) && \
    make install

# arachne-pnr
RUN git clone https://github.com/YosysHQ/arachne-pnr.git arachne-pnr && \
    cd arachne-pnr && \
    make -j$(nproc) && \
    make install

USER $USER

####### Startup Script ####################################

USER root
WORKDIR /
# run the startup script each time the container is created
COPY ./startup-fpgaflow.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh
ENTRYPOINT ["/opt/startup.sh"]

