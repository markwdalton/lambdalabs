

There are a lot of tutorials on python programming on line.  Here are a few.

* https://pytorch.org/tutorials/distributed/home.html - many sub-tutorials
* https://pytorch.org/tutorials/beginner/dist_overview.html - many sub-tutorials
* https://pytorch.org/tutorials/beginner/ddp_series_theory.html
* https://pytorch.org/tutorials/beginner/ddp_series_multigpu.html
* https://huggingface.co/docs/transformers/perf_train_gpu_many
* https://pytorch.org/tutorials/beginner/former_torchies/parallelism_tutorial.html
* https://pytorch.org/tutorials/beginner/blitz/data_parallel_tutorial.html
* https://github.com/NVIDIA/apex/issues/282

Lambda Tutorial:
   https://lambdalabs.com/blog/multi-node-pytorch-distributed-training-guide

Single Node - Multi-GPU training:
   https://pytorch.org/tutorials/beginner/ddp_series_multigpu.html

Multi-node training:
   https://pytorch.org/tutorials/intermediate/ddp_series_multinode.html


Running this example shows you for a 2x GPU machine <A HREF="https://github.com/markwdalton/lambdalabs/tree/main/documentation/software/multi-gpu/pytorch-example-multi-gpu.py">pytorch-example-multi-gpu.py</A> 

```python
$ python pytorch-example-multi-gpu.py
Let's use 2 GPUs!
	In Model: input size torch.Size([15, 5]) output size torch.Size([15, 2])
	In Model: input size torch.Size([15, 5]) output size torch.Size([15, 2])
Outside: input size torch.Size([30, 5]) output_size torch.Size([30, 2])
	In Model: input size torch.Size([15, 5]) output size torch.Size([15, 2])
	In Model: input size torch.Size([15, 5]) output size torch.Size([15, 2])
Outside: input size torch.Size([30, 5]) output_size torch.Size([30, 2])
	In Model: input size torch.Size([15, 5]) output size torch.Size([15, 2])
	In Model: input size torch.Size([15, 5]) output size torch.Size([15, 2])
Outside: input size torch.Size([30, 5]) output_size torch.Size([30, 2])
	In Model: input size torch.Size([5, 5]) output size torch.Size([5, 2])
	In Model: input size torch.Size([5, 5]) output size torch.Size([5, 2])
Outside: input size torch.Size([10, 5]) output_size torch.Size([10, 2])
```
