# lambdalabs - software debugging
For python, tensorflow, pytorch the most common issue is locally installed software or the use of virtual environments.
Commonly these issues are due to conflicting versions are found in ~/.local or /usr/local.
But also can be issues in Virtual Environments not pointing to consistent libraries.
   1. Libraries need to be consistent with the TensorFlow and PyTorch builds (libcudnn, libnvinfer are two of the more common libraries).
   2. Anaconda ignores /usr/lib install python modules
..       -> This still looks in ~/.local and /usr/local and it can conflict
..       -> All requirements need to be installed
..       -> Anaconda does not setup the LD_LIBRARY_PATH for its library installs for some packages like cuDNN.

   3. Python venv can create a venv in two ways:
..       a. Default with a full environment (ignoring LambdaStack):
....          $ python -m venv  my_env
..       b. Using the system installed packages (it can see /usr/lib and Lambda Stack), then you only need to add some modules.
....          $ python -m venv --system-site-packages my_env
....          -> This can result in conflicts with the library versions in /usr/lib versus the local modules/libraries installed depending on versions.

..      NODE:
..        -> Both can result in conflicts with ~/.local and /usr/local
..        -> Both can at times not setup the LD_LIBRARY_PATH for some libraries

Debugging:
  1. To see what python modules you are using:
..       $ pip -v list | more
..     A quick way to see software installed outside of Lambda Stack:
..       $ pip -v list | egrep -v "/usr/lib/python3"
  2. The quick way to resolve the conflict:
..     Move the directories:
..        a. Move the ~/.local out of the way.
..           $ mv ~/.local ~/.local.bak
..        b. Move /usr/local out of the way 
..              ** NOTE: This affects all users on the system
..              ** NOTE: Some packages are at times installed here, so be aware of this).
..           (/usr/local - is suppose to ONLY be the sites local software, not 3rd party commercial/organizational software).
..     Alternative method is to remove all packages in the list:
..        a. Uninstall each package in ~/.local
..           $ pip unintall <package-name>
..        b. Uninstall each page in /usr/local (as root via sudo - be aware this affects all users)
..           $ sudo pip uninstall <package-name>

