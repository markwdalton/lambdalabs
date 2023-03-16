**Anaconda**
Common thigs with Anaconda are:
 * Older compiled software
 * It does not setup LD_LIBRARY_PATHs at times like for cudnn
 * It installs its entire environment including its own python
 * Licensing changed in the last few years please read it for company use
 * NOTE: pip installs done to ~/.local and to /usr/local affect environments
         (pip -v list will show software used in other paths)

See the anaconda-cheatsheet and examples.

```
1. List Anaconda environments:
   conda info --envs
  or
   conda env list
2. List Packages in the Conda environment:
   $ conda activate
   (base) $ conda list
   (base) $ pip -v list

3. Create a environment:
     a. With a YAML file
        $ conda env create -f ~/conda-yaml/torch_gpu.yml
   or
     b. Create from the command line:
        $ conda create --name torch_gpu pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia

4. Using the environment: (where 'torch_gpu' is showsn in 'conda env list'
      conda activate torch_gpu

5. Stop using/deactivate the env:
      conda deactivate

6. Removing a environment
      conda env remove -n <name>
```

The main issue is fixing the CuDNN library path:
```
Just add the following to Anaconda:
     a. Show where the cudnn library is installed:
         $ find ${CONDA_PREFIX} -name '*libcudnn.so*'
         /home/mark/miniconda3/envs/tf_gpu/lib/libcudnn.so.8.2.1
         /home/mark/miniconda3/envs/tf_gpu/lib/libcudnn.so.8
         /home/mark/miniconda3/envs/tf_gpu/lib/libcudnn.so

    b. Setup the library path so applications can find the libraries:
        ## Anaconda/Miniconda do not correctly setup the path for this library (even though it installs it).
        export LD_LIBRARY_PATH=${CONDA_PREFIX}/lib:${LD_LIBRARY_PATH}
```
