import torch

print("\nPytorch version: ",torch.__version__)
print(torch._C._cuda_getCompiledVersion(), "cuda compiled version")
print("\ntorch",torch.__file__)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print("Device name: ", torch.cuda.get_device_name(device))
print("Device properties: ", torch.cuda.get_device_properties(device))
print("Device_count: ", torch.cuda.device_count())
