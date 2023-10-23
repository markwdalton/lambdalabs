### Using Slurm with Singularity

#####Running generally with Slurm:
* Interactive runs:
```
Run one task on one node with one GPU, interactively (default time):
$ srun --ntasks=1 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 --pty bash -i

Run a job for 30 minutes, interactively on 8 tasks per node on two nodes with 8 GPUs on each:
$ srun --nodes=16 --ntasks-per-node=8 --gres=gpu:8 --gpus-per-node=8 --time=00:30:00 --pty bash -i

Also you can get around bugs in some versions by using salloc:
$ salloc --nodes=16 --ntasks-per-node=8 --gres=gpu:8 --gpus-per-node=8 --time=00:30:00
salloc: Pending job allocation 4321 
salloc: job 4321 queued and waiting for resources
salloc: job 4321 has been allocated resources
salloc: Granted job allocation 4321
To attach to it: (srun --jobid=<jobid> --pty /bin/bash):

$ srun --jobid=4321 --pty /bin/bash

(node) $ mpirun python -c 'import tensorflow as tf; print(tf.__version__)'

Interactive sessions do end if you exit the shell/internet issues or time expires.
tmux can be used to avoid internet issues.  Just start the tmux session prior to starting the job.
```
* Batch command line:
```
$ srun --ntasks=1 --ntasks-per-node=1 --gres=gpu:1 --gpus-per-node=1 nvidia-smi
```
* You can use a batch file also and just run `sbatch 
```
$ chmod 700 myjob.sh
$ cat myjob.sh
#!/bin/bash
#SBATCH --ntasks=16                    # Run 16 total tasks
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:8
#SBATCH --gpus-per-node=8
## #SBATCH --network=DEVNAME=mlx5_ib,DEVTYPE=IB    # define if on a IB network
#SBATCH --job-name=slurm-mpi-tf
#SBATCH --output=job-%x.%j.out
## #SBATCH --mem=4                       # Job memory request
## #SBATCH --time=00:05:00               # Time limit hrs:min:sec
mpirun python -c 'import tensorflow as tf; print(tf.__version__)'

$ sbatch myjob.sh
  The job output will return to a file in your directory, in this instance the name would be:
    -> job-slurm-mpi-tf.<jobid>.out
```
Monitoring Slurm:
```
List Nodes status:
$ sinfo
$ scontrol show node <nodename>
List Jobs:
$ squeue
Cancel a job:
$ scancel <jobid>
Lists detailed information for a job:
$ scontrol show jobid -dd <jobid>
```

##### Working with Singularity:
* NOTE: To run with GPUs, use the '--nv' option:
```
  $ singularity <command> --nv <container>  script
example 'exec' will execute a command/script on that container
  $ singularity exec --nv <container> script
example 'run' will run the container with its default action
  $ singularity run --nv <container> 
```

* How to setup to a alternative shared cache directory:
```
   Where '/scratch/<fileystem>/' is a shared file system across nodes, ideally fast
     $ export SINGULARITY_CACHEDIR=/scratch/<fileystem>/$USER
     $ singularity pull docker://godlovedc/lolcow
     $ singularity cache list --type=library,oci -v
```
* Converting a docker image to a singularity image:
```
     $ singularity pull docker://nvcr.io/nvidia/pytorch:21.06-py3
        -> by default this will get converted and stored in your cache in ${HOME}/.singularity/cache
```
* Running the converted docker, example:
```
  $ singularity exec --nv pytorch_21.06-py3.sif python -c 'import torch ; print("Is available: ", torch.cuda.is_available()) ; print("Current Device: ", torch.cuda.current_device()) ; print("Pytorch CUDA Compiled version: ", torch._C._cuda_getCompiledVersion()) ; print("Pytorch version: ", torch.version) ; print("pytorch file: ", torch.__file__)'
  
  Is available:  True
  Current Device:  0
  Pytorch CUDA Compiled version:  11030
  Pytorch version:  <module 'torch.version' from '/opt/conda/lib/python3.8/site-packages/torch/version.py'>
  pytorch file:  /opt/conda/lib/python3.8/site-packages/torch/__init__.py
```
* Example 2 with newer Python CUDA 12.2 (example running with a shell and then running)
```
   $ singularity shell --nv docker://nvcr.io/nvidia/pytorch:23.09-py3
   Singularity> python ./torch-test.py
      Is available:  True
      Current Device:  0
      Pytorch CUDA Compiled version:  12020
      Pytorch version:  2.1.0a0+32f93b1
      pytorch file:  /usr/local/lib/python3.10/dist-packages/torch/__init__.py
      List GPUs:
         NVIDIA RTX A4000
         NVIDIA RTX A4000
         NVIDIA RTX A4000
         NVIDIA RTX A4000
         NVIDIA RTX A4000
         NVIDIA RTX A4000
         NVIDIA RTX A4000
         NVIDIA RTX A4000
```
* Cleaning the singularity cache:
```
   List images:
      $ singularity cache list --type=library,oci -v
   List everything:
      $ singularity cache list -v
   Clean ALL images in the cache:
      $ singularity cache clean 
   Cleaned specific containers:
      $ singularity cache clean -N <IMAGE_NAME>

      Example, clearing the image 'ubuntu_16.04.sif'
         $ singularity cache clean -N ubuntu_16.04.sif

      Or to clear all blobs:
         $ singularity cache clean -T blob
```
* And if you want a 'shared space' for images, a standard image you want to share:
```
     For example on a Shared file system in this case "/share" would be mounted on all nodes.
     It would enable all users to use shared images, recommended writable only by root.
        srun --gres=gpu:1 -n 1 singularity run --containall /share/images/lolcow_latest.sif

   * If you have global images for anyone to use
   * This can be created with:
       $ sudo mkdir -p /share/images
       $ sudo cp ${HOME}/.singularity/cache/library/sha256.e37e11f101a9db82a08bf63f816219da0d4da0e19f5323761d92731213c9e751/lolcow_latest.sif /share/images

   And you can still run images from your local cache or download to your local cache: ${HOME}/.singularity/cache
    srun --gres=gpu:1 -n 1 singularity run lolcow_latest.sif
    * This would use your default cache which is in ${HOME}/.singularity/...
       It can be changed by: SINGULARITY_CACHEDIR=
       But the user needs to be able to write there and each node needs to see this directory.
```
* Slurm Plugins is another topic:
...And if you want the slurm plugin, I have a few existing plugs I can use or we can write one.
...https://git.biohpc.swmed.edu/biohpc/singularity/-/tree/6a219a05fa192f75f420461334404d16dfbb9416/src/slurm
...https://github.com/grondo/slurm-spank-plugins
...https://github.com/sol-eng/singularity-rstudio/blob/main/slurm-singularity-exec.md
...These are just examples of other ways to run or add functionality things like:
...Singularity options
...Node Health Check
...Job cleanup
...misc

* Example runs:
* Run from Local user cache:
```
     $ srun --gres=gpu:1 -n 1 singularity --nv run lolcow_latest.sif
       * This would use your default cache which is in ${HOME}/.singularity/...
         It can be changed by: SINGULARITY_CACHEDIR=
         But the user needs to be able to write there and each node needs to see this directory.
```
* This will pull and run on a image from the sylab:
```
     $ srun --gres=gpu:1 -n 1 --nv singularity run library://sylabsed/examples/lolcow
  Download from docker: (to your local cache and run):  (NOTE This takes a long time to convert from docker to singularity).
     $ srun --gres=gpu:1 -n 1 --nv singularity exec --nv docker://nvcr.io/nvidia/pytorch:23.09-py3 python -c 'import torch ; print("Is available: ", torch.cuda.is_available()) ; print("Current Device: ", torch.cuda.current_device()) ; print("Pytorch CUDA Compiled version: ", torch._C._cuda_getCompiledVersion()) ; print("Pytorch version: ", torch.__version__) ; print("pytorch file: ", torch.__file__)'
```
* To save to shared directory:
...This will just shows the singularity and docker converted images:
```
       $ singularity cache list --type=library,oci -v
          NAME                     DATE CREATED           SIZE             TYPE
          lolcow_latest.sif        2023-10-11 21:38:41    83.79 MB         library
          pytorch_23.09-py3.sif    2023-10-11 21:57:10    9.86 GB          oci

          There are 2 container file(s) using 9.94 GB of space
          Total space used: 9.94 GB
```
* Find the full path of the image:
```
       $ find ~/.singularity -name '*.sif'
       /home/support/.singularity/cache/library/sha256.e37e11f101a9db82a08bf63f816219da0d4da0e19f5323761d92731213c9e751/lolcow_latest.sif
       /home/support/.singularity/cache/oci-tmp/b62b664b830dd9f602e2657f471286a075e463ac75d10ab8e8073596fcb36639/pytorch_23.09-py3.sif
```
* If not already done, create shared directory (That should be shared across the nodes) 
```
       $ sudo mkdir -p /share/images
       $ find ~/.singularity -name '*.sif'
         * Copy the images out to the 'shared area' - either rename or co-ordinate with other users on the 'new version'
```
* Copy the image to the /share/images directory:
```
       $ sudo cp ${HOME}/.singularity/cache/library/sha256.e37e11f101a9db82a08bf63f816219da0d4da0e19f5323761d92731213c9e751/lolcow_latest.sif /share/images
       $ sudo cp ~/.singularity/cache/oci-tmp/b62b664b830dd9f602e2657f471286a075e463ac75d10ab8e8073596fcb36639/pytorch_23.09-py3.sif /share/images
```
* Perhaps you have a different flavor of a image, just rename or version it:
```
       $ sudo cp ${HOME}/.singularity/cache/library/sha256.e37e11f101a9db82a08bf63f816219da0d4da0e19f5323761d92731213c9e751/lolcow_latest.sif /share/images/nathans-lolcow_202319011.sif
```
* Run using a Shared directory:
```
     user@login1:~$ srun --gres=gpu:1 -n 1 singularity exec --nv /share/images/pytorch_23.09-py3.sif python -c 'import torch ; print("Is available: ", torch.cuda.is_available()) ; print("Current Device: ", torch.cuda.current_device()) ; print("Pytorch CUDA Compiled version: ", torch._C._cuda_getCompiledVersion()) ; print("Pytorch version: ", torch.__version__) ; print("pytorch file: ", torch.__file__)'

     Is available:  True
     Current Device:  0
     Pytorch CUDA Compiled version:  12020
     Pytorch version:  2.1.0a0+32f93b1
     pytorch file:  /usr/local/lib/python3.10/dist-packages/torch/__init__.py
```

#### Pulling or using Ubuntu from Singularity Library
```
user@login1:~$ singularity exec library://ubuntu:20.04 grep PRETTY /etc/os-release
INFO:    Downloading library image
PRETTY_NAME="Ubuntu 20.04.4 LTS"

user@login1:~$ singularity exec library://ubuntu:22.04 grep PRETTY /etc/os-release
INFO:    Downloading library image
PRETTY_NAME="Ubuntu 22.04 LTS"
```
