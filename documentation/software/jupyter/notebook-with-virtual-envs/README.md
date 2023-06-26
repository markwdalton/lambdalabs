##Running Jupyter notebook with multiple environments

1. Setup the first environment with Python venv
```
   $ cd src/embed
   $ python -m venv embed_env
   $ source embed_env/bin/activate
   (embed_env) $ pip install -r requirements.txt
   (embed_env) $ python -m pip install ipykernel
   (embed_env) $ ipython kernel install --user --name=embed_env
```
2. Setup a second environment with Anaconda
```
   $ conda env create -f environment.yml
   $ conda activate pix2pix3d
   (pix2pix3d) $ python -m pip install ipykernel
   (pix2pix3d) $ python -m ipykernel install --user --name=pix2pix3d
```
3. Check they are installed
```
   $ jupyter kernelspec list
     Available kernels:
       embed_env    /home/username/.local/share/jupyter/kernels/embed_env
       pix2pix3d    /home/username/.local/share/jupyter/kernels/pix2pix3d
       python3      /home/username/.local/share/jupyter/kernels/python3
```
4. Start Jupyter notebook or Jupyter lab.  You do not need the environment activated.
```
   $ jupyter notebook
  or
   $ jupyter lab

   [I 09:14:00.275 NotebookApp] Serving notebooks from local directory: /home/username/.jupyter
   [I 09:14:00.275 NotebookApp] Jupyter Notebook 6.4.8 is running at:
   [I 09:14:00.275 NotebookApp] https://lambda-dual:9999/
```
Select the Environment:
![alt_text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/software/jupyter/notebook-with-virtual-envs/jupyter-notebook-select-environment.jpg) "Jupyter Notebook Select Environment")

Confirm the environment in Jupyter Notebook with pip:
![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/software/jupyter/notebook-with-virtual-envs/jupyter-notebook-confirm-pip.png "Jupyter Notebook confirm pip install")

5. You can make it accessable to remote hosts:

..*Use a SSH tunnel to access the host port
..*You can also setup a SSL certificate (self-signed or with a valid IP a registered one).  Then you could go to a open IP address for remote use.

