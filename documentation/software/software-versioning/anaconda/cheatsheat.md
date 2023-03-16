
A. Create a YAML file:
  1. Example:
     name: tf-gpu8
     
     channels:
       - pytorch
       - conda-forge
       - nvidia
       - defaults
     
     dependencies:
       - cudatoolkit=11.1.74
       - cudnn
       - nccl
       - pip
       - pandas
       - matplotlib
       - python>=3.8.5
       - tensorflow=2.4.1
       - tensorflow-gpu=2.4.1
       - pip:
          - networkx
          - tqdm
          - matplotlib
          - pydot
          - graphviz

  2. Search for versions:
     conda search -c nvidia cudatoolkit
     conda search -c nvidia tensorflow
     conda search -c nvidia tensorflow-gpu
   

B. Creating and using the Environments:
   1. Create a environment:
      conda env create -f ~/conda-yaml/tf-gpu.yaml

   2. List environments:
      conda env list
      conda info --envs
     
   3. Using the environment:
      conda activate tf-gpu

   4. Stop using/deactivate the env:
      conda deactivate

   5. Removing a environment
      conda env remove -n <name>


Example:
$ conda env list
  # conda environments:
  #
  base                  *  /home/user/anaconda3
  tf-gpu                   /home/user/anaconda3/envs/tf-gpu
  tf-gpu8                  /home/user/anaconda3/envs/tf-gpu8
  
$ conda env remove -n tf-gpu

  Remove all packages in environment /home/user/anaconda3/envs/tf-gpu:

