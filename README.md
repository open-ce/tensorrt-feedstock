# tensorrt-feedstock

To build TensorRT:

1. Download Tensorrt distribution archive from NVIDIA's downloads page 
"https://developer.nvidia.com/nvidia-tensorrt-7x-download". This step requires authentication. 
2. Supply path for the downloaded file to the build script using:
	- command line argument to build_package.py script 
   or
	- "local_src_dir" key in config/build-config.yaml file. 
The path supplied as command line argument takes higher priority over the 
path specified in the build-config.yaml.

NOTE:
Some parts of TensorRT do not currently work with Python 3.8.
