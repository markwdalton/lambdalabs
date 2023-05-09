# multi-GPU Programming

For writing your code to take advantage of the NVLink or multi-GPU programming
there are various models.  Commonly is DDP - Data Distributed Programming where
the same model is on each GPU and you run in parallel over that model.

NVLink allows you to have fast access between GPUs that are linked.
* To see linked GPUs, this will show a matrix of which GPUs are linked
```bash
   $ nvidia-smi topo -m
```

* To the speed of each of the lanes per link
```bash
   $ nvidia-smi nvlink -s
```
For Pytorch guides see: <A HREF="https://github.com/markwdalton/lambdalabs/tree/main/documentation/software/multi-gpu/PyTorch-examples.md">PyTorch-examples.md</A> 

First you should understand the type of parallelism you want:
- https://huggingface.co/transformers/v4.9.0/parallelism.html
From the above, summary:

- Data Parallelism (DP) - easy to use
- Distributed Data Parallelism (DDP) - this is typically faster and easy to use
- Fully Shared Data Parallel(FSDP) - FSDP is a type of data parallelism that shards model parameters, optimizer states and gradients across DDP ranks.
<p>    https://pytorch.org/blog/introducing-pytorch-fully-sharded-data-parallel-api/</p>
- ZeRO Data Parallel(ZeRO-DP) - each GPU stores a slice (and a alternate Sharded DDP)
- Model Parallel (MP) - spreads groups of models across GPUs (vertically)
- Pipeline Parallel (PP) - chunking the incoming batch into micro-batches and artificially creating a pipeline
- Tensor Parallel (TP) - each GPU processes only a slice of a tensor and only aggregates the full tensor for operations that require the whole thing
- FlexFlow - solves in a alternate way, parallelism over Sample-Operator-Attribute-Parameter
- Elastic Training - dynamically scale training resources for deep learning models, running PyTorch jobs on multiple GPUs and/or machines
<p>     * as described https://www.run.ai/guides/multi-gpu/pytorch-multi-gpu-4-techniques-explained </p>
  
..  And you can mix these DP+PP, DP+PP+TP, DP+PP+TP+ZeRO
..  This covers the 'which to use when' question also.

#Next is how you do parallel across nodes, Distributed Communication packages:
<p>*https://pytorch.org/docs/stable/distributed.html</p>
<p></p>
* NCCL - https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/overview.html - likely the fastest solution for GPUs
* GLOO - https://github.com/facebookincubator/gloo
* MPI - https://mpi4py.readthedocs.io/en/stable/tutorial.html - Python implementation is not as good as MPI in other langauges.

