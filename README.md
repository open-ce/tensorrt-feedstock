# tensorrt-feedstock

This repository is one of several that comprise the broader [**Open-CE**](https://github.com/open-ce) project. Each feedstock repository provides a conda-based build framework for a specified package within [**Open-CE**](https://github.com/open-ce).

These feedstock repositories do not contain the source code for the corresponding packages themselves. Instead, they contain the automated means to build the desired package from the officially designated source location.

The [**Open-CE**](https://github.com/open-ce) project has a separate central controlling repository which coordinates the overall build, dependencies, and documentation requirements of the project. The central repository is named for the project itself, [open-ce](https://github.com/open-ce/open-ce).

For more information about the project, and for instruction on how to build this and other feedstock packages, please refer to the **Open-CE** [README.md](https://github.com/open-ce/open-ce/blob/main/README.md) file in the central repository. This should be your reference starting point before turning to the feedstock repositories themselves.


# Building TensorRT

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
