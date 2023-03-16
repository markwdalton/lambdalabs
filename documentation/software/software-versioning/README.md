**Lambda Stack currently is not versioned.**

But you can version python, PyTorch, TensorFlow with various tools

The common solutions for versioning are:
1. Docker
2. Python venv (any flavor venv from python, virtualenv, etc ).
3. Anaconda/miniconda - I give out a YAML example of setup with a how to.

```
Virtual environments with:

This is a Preview of the "Training YoloV5 face detector on Lambda Cloud"
https://lambdalabs.com/blog/p/0145d2e7-de64-4ca0-9741-dd510ff6ca63/

Anaconda:
  https://lambdalabs.com/blog/setting-up-a-anaconda-environment/
   - Also anaconda does not set the path when it install cudnn so you need to set that
     export LD_LIBRARY_PATH=${CONDA_PREFIX}/lib:${LD_LIBRARY_PATH}

Docker tutorial:
   https://lambdalabs.com/blog/nvidia-ngc-tutorial-run-pytorch-docker-container-using-nvidia-container-toolkit-on-ubuntu/
```

