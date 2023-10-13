#### Building singularity/sif containers
* This is a pretty straight forward process
* There is excellent documentation at:
..* https://docs.sylabs.io/guides/3.0/user-guide/build_a_container.html
..* https://docs.sylabs.io/guides/3.7/user-guide/definition_files.html

You can see official images at docker and NVIDIA:
..* https://hub.docker.com/search?image_filter=official
..* https://catalog.ngc.nvidia.com/

##### Simple example:
* Create a Definition file 'my-lolcow.def':
```
Bootstrap: docker
From: ubuntu:16.04

%post
    apt-get -y update
    apt-get -y install fortune cowsay lolcat

%environment
    export LC_ALL=C
    export PATH=/usr/games:$PATH

%runscript
    fortune | cowsay | lolcat
```
* Building the sif image from the definition:
```
Either:
   $ sudo /opt/singularity/3.5.3/bin/singularity build my-lolcow3.sif my-lolcow.def
Or:
   $ docker run --privileged --rm -v ${PWD}:/home/singularity quay.io/singularity/singularity:v3.5.3 build /home/singularity/my-lolcow2.sif /home/singularity/my-lolcow.def
```
