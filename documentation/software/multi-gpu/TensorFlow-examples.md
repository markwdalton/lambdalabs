
# Multi-GPU training in TensorFlow

* https://www.tensorflow.org/guide/distributed_training
* https://www.tensorflow.org/api_docs/python/tf/distribute/Strategy
* And for Kereas: https://www.tensorflow.org/tutorials/distribute/keras

MirroredStrategy is the most common

With tf.distribute.<option> there are a number of Stretegies are:
* MirroredStrategy
* TPUStrategy
* MultiWorkerMirroredStrategy
* ParameterServerStrategy
* CentralStorageStrategy
