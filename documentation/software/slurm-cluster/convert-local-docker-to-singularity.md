
###Converting a docker image to a sif file:

#### Convert a Docker image to sif file:
* Note some images take a while to convert the first time like the PyTorch image
* Also other images like 'hello-world' do not have a shell nor login/passwd so are not valid

##### Quick example:
```
If you just want to build the file and not place it in your cache:
user@login1:~$ singularity build lolcow.sif docker://godlovedc/lolcow
user@login1:~$ srun --ntasks=2 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 singularity exec ./lolcow.sif grep PRETTY /etc/os-release
PRETTY_NAME="Ubuntu 16.04.3 LTS"
PRETTY_NAME="Ubuntu 16.04.3 LTS"
```

##### Longer example:
```
user@login1:~$ singularity pull docker://nvcr.io/nvidia/pytorch:21.06-py3
        -> by default this will get converted and stored in your cache in ${HOME}/.singularity/cache

user@login1:~$ singularity cache list -v -T oci
NAME                     DATE CREATED           SIZE             TYPE
pytorch_21.06-py3.sif    2023-10-12 09:34:41    5.51 GB          oci

There are 3 container file(s) using 5.60 GB of space
Total space used: 5.60 GB
```

#### Convert a locally built docker image to a sif file
```
user@login1:~$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED        SIZE
my-image   latest    0b8ea7bff30a   17 hours ago   14.7GB

user@login1:~$ docker save 0b8ea7bff30a -o my-image.tar

user@login1:~$ singularity build --sandbox my-image docker-archive://my-image.tar
INFO:    Starting build...
Getting image source signatures
Copying blob b93c1bd012ab done
Copying blob f1c52a5f1f6e done
   ...

To test the shell
  user@login1:~$ singularity shell my-image
  user@login1:~$ singularity exec my-image grep PRETTY /etc/os-release
  PRETTY_NAME="Ubuntu 22.04.2 LTS"

   user@login1:~$ singularity run my-image

To Convert the image:
user@login1:~$ singularity build my-image.sif my-image
INFO:    Starting build...
INFO:    Creating SIF file...
INFO:    Build complete: my-image.sif

And run the image:
user@login1:~$ singularity run ./my-image.sif

=============================
== Triton Inference Server ==
=============================

You can create a shared area that is on each node:
$ sudo mkdir -p /home/shared/images

Then can copy it to the shared area:
$ sudo cp ./my-image.sif /home/shared/images/
```

Then to run either from the local file or the image in /home/shared/images:
```
user@login1:~$ srun --ntasks=2 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 singularity exec ./my-image.sif grep PRETTY /etc/os-release
PRETTY_NAME="Ubuntu 22.04.2 LTS"
PRETTY_NAME="Ubuntu 22.04.2 LTS"
user@login1:~$ srun --ntasks=2 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 singularity exec ./my-image.sif uname -n
compute06
compute07

Or from the image in /home/shared/images, once you want to share it:
the image in /home/shared/images:
user@login1:~$ srun --ntasks=2 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 singularity exec /home/shared/images/my-image.sif grep PRETTY /etc/os-release
PRETTY_NAME="Ubuntu 22.04.2 LTS"
PRETTY_NAME="Ubuntu 22.04.2 LTS" 

user@login1:~$ srun --ntasks=2 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 singularity exec /home/shared/images/my-image.sif uname -n
compute06
compute07
```
