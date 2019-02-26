## Contents:

* Dockerfile: to build the basic spinalhdl:dev image
* Interactive.dockerfile: to build a spinalhdl:full image

## how to build a full featured environment on your linux workstation
<pre>docker image build -f Dockerfile -t spinalhdl:dev
</pre>
than
<pre>docker image build -f Interactive.dockerfile -t spinalhdl:full
</pre>

//TODO: Interactive.dockerfile and description what these images offer
