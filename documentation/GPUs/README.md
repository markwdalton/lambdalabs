NVIDIA GPUs and common questions/issues.

1. nvidia-smi Driver versus CUDA version
   * nvidia-smi shows the Driver version, and the max version of CUDA the driver supports.
   * The driver needs to support the same or new version of CUDA than you are using.
2. The main issue with 'compatability' is with the CUDA or cuDNN for the version of 
   PyTorch or TensorFlow was built with.
   See: <A HREF="https://github.com/markwdalton/lambdalabs/tree/main/python-scripts">Python scripts</A> for examples to see
       what version it is built with or location that your environment is using.
3. Seeing the versions of python modules you are using, this is the most common problem python users run into for conflicts.
   When local pip is used without versioning either ${HOME}/.local or /usr/local installed tools may work for one code and
   break another.
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
      <dt>Python venv
      <dt>Docker/Singularity
      <dt>Anaconda/Miniconda - note license changed in the last few years from free - to non-commercial use

