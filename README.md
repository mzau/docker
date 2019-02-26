## Contents:

* Dockerfile: to build the basic spinalhdl:spinalhdl image  (Note: this file is unmodified clone from SpinalHDL/docker)
* interactive/FPGA.dockerfile: to build a spinalhdl:yosysflow image
* interactive/Interactive.dockerfile: to build a spinalhdl:dev image

The Idea: Have different levels of docker images wich are
* Travis-CI level - image spinalhdl:spinalhdl
* Yosys interactive level, based on Travis-CI level with Yosys workflow for FPGA (without Softcores and firmware dev tools) - image spinalhdl:yosysflow
* IDE level based on Yosys level with IDE for developing SpinalHDL based designs - image spinalhdl:dev

## how to build a full featured environment on your linux workstation
<pre>docker image build -f Dockerfile -t spinalhdl:spinalhdl
</pre>
than
<pre>cd interactive
docker image build -f FPGA.dockerfile -t spinalhdl:yosysflow
</pre>
than
<pre>
docker image build -f Interactive.dockerfile -t spinalhdl:dev
</pre>

## Howto use the images
### To use FPGA Workflow only
From a terminal window type:
<pre>docker run -it  spinalhdl:yosysflow
</pre>
this will bring you into a bash shell in user directory /home/spinaldev.
You can check if all tools are in place:
<pre>ls /usr/local/bin
<pre/>
returns
<pre>
arachne-pnr     icebox_explain  icemulti      verilator                   yosys
ghdl            icebox_hlc2asc  icepack       verilator_bin               yosys-abc
ghdl1-llvm      icebox_html     icepll        verilator_bin_dbg           yosys-config
icebox.py       icebox_maps     iceprog       verilator_coverage          yosys-filterlib
icebox_asc2hlc  icebox_stat     icetime       verilator_coverage_bin_dbg  yosys-smtbmc
icebox_chipdb   icebox_vlog     iceunpack     verilator_gantt
icebox_colbuf   iceboxdb.py     iverilog      verilator_profcfunc
icebox_diff     icebram         iverilog-vpi  vvp
</pre>

Installed editors are vim and nano. To keep the image small, no gui tools needing X are installed.

Note that exiting the shell removes the container and all changed or new data is lost!

### spinalhdl:dev usage

###TODOs
* description what these images offer
* show how to add a volume for pemanent work storage

