import tensorflow as tf

sys_details = tf.sysconfig.get_build_info()
# cuda_version = sys_details["cuda_version"]
print(sys_details)

