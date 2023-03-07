import tensorflow as tf
print("\nTensorflow version: ",tf.__version__, "\nTensorflow file: ",tf.__file__)
print("Num GPUs Available: ", len(tf.config.experimental.list_physical_devices("GPU")))
print(tf.version.GIT_VERSION, tf.version.VERSION)
print("GPUs available: \n", tf.config.experimental.list_physical_devices("GPU"))
