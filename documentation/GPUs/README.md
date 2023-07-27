NVIDIA GPUs and common questions/issues.

1. We have seen issues with GPUs or other devices not being seen.
   * BAR memory use issues - update BIOS: SR_IOV=Enabled
   * Update Kernel Boot Parameters: 'pci=realloc=off'
   * More detail can be seen in [updating kernel parameters](https://github.com/markwdalton/lambdalabs/blob/main/documentation/linux/linux-kernel-boot-options.md)
2. nvidia-smi Driver versus CUDA version
   * nvidia-smi shows the Driver version, and the max version of CUDA the driver supports.
   * The driver needs to support the same or new version of CUDA than you are using.

```
    $ nvidia-smi | head -8
    Wed Mar  8 14:19:00 2023       
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 525.85.05    Driver Version: 525.85.05    CUDA Version: 12.0     |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |                               |                      |               MIG M. |
    |===============================+======================+======================|
```
    This will show Driver Version: 525.85.05 which supports UPTO CUDA Version 12.0
     * The version of CUDA you are actually using depends on your environment:
         - What libraries and python modules were installed on your system
         - What you have installed with pip - which over ride system install
         - What you have in your virtual environment, to see what you installed:
             `pip -v list` 

2. The main issue with 'compatability' is with the CUDA or cuDNN for the version of 
   PyTorch or TensorFlow was built with.
   See: <A HREF="https://github.com/markwdalton/lambdalabs/tree/main/python-scripts">Python scripts</A> for examples to see
       what version it is built with or location that your environment is using.
3. Seeing the versions of python modules you are using, this is the most common problem python users run into for conflicts.
   When local pip is used without versioning either ${HOME}/.local or /usr/local installed tools may work for one code and
   break another.
```
      $ pip -v list > pip.txt
      **This will show the version and the path of the install**
      Lambda Stack software is installed in:
           /usr/lib/python3/dist-packages

   The solution is normally to remove local installs:
      $ mv ~/.local ~/.local.bak
      $ sudo mv /usr/local /usr/local.bak
          *This issue with /usr/local some vendors wrongly install in this local site directory, /opt/<org>/<package> is the correct location*
          *Also you may have local site packages installed here*

   Then use a virtual environment for python:
      * Python venv * Two ways to do this:
          a. Independant and install all needed packages ('my_env' can be any name)
             $ python -m venv my_env
             $ . ./my_env/activate
             $ pip install <all required packages>
          b. Use default system packages (less reliable with TensorFlow as library conflicts) (
             $ python -m venv --system-site-packages my_use_system_env
             $ . ./my_use_system_env/bin/activate
             $ pip install <other required packages>
      * Docker/Singularity
      * Anaconda/Miniconda - note license changed in the last few years from free - to non-commercial use
```
