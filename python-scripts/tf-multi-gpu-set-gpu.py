import tensorflow as tf

gpus = tf.config.list_physical_devices('GPU')

if gpus:
  try:
    # Currently, memory growth needs to be the same across GPUs
    for gpu in gpus:
      tf.config.experimental.set_memory_growth(gpu, True)
    logical_gpus = tf.config.list_logical_devices('GPU')
    print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
  except RuntimeError as e:
    # Memory growth must be set before GPUs have been initialized
    print(e)

try:
  # Specify an invalid GPU device
  print("Setting device GPU:")
  tf.config.list_logical_devices('GPU')
  print("Set device to GPU 1: (if you have 2+ GPUs)")
  with tf.device('/device:GPU:1'):
    a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
    b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
    c = tf.matmul(a, b)
    print(c)
    my_gpus = tf.config.list_logical_devices('GPU')
    print(len(gpus), "Physical GPUs,", len(my_gpus), "Logical GPUs")
except RuntimeError as e:
  print(e)

