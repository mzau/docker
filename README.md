## Contents:

* Dockerfile: to build the basic spinalhdl:spinalhdl image
* Interactive.dockerfile: to build a spinalhdl:dev image

## how to build a full featured environment on your linux workstation
<pre>docker image build -f Dockerfile -t spinalhdl:spinalhdl
</pre>
than
<pre>docker image build -f Interactive.dockerfile -t spinalhdl:dev
</pre>

//TODO: Interactive.dockerfile and description what these images offer
