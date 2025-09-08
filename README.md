# MLIR (Un)School Docker

# Monday: Introduction To MLIR - deep dive

## Installation of the Docker

*Note: To run docker without sudo once you have install it, please follow the post-installation instructions: https://docs.docker.com/engine/install/linux-postinstall/*

You can download a prebuilt docker image by running:
```
docker pull electrikspace/mlir-tutorial:debug
```
Then you can run the docker and work inside with:
```
docker run -it electrikspace/mlir-tutorial:debug
```

# Tuesday: Define your Dialect

## Installation

The session is a hand-on where you will actually modify an out-of-tree MLIR project (named *mlir-list*). To build it, you need an environment with prebuilt llvm-project:

### Option 1: With Docker

*Note: To run docker without sudo once you have install it, please follow the post-installation instructions: https://docs.docker.com/engine/install/linux-postinstall/*

This is the simpliest option. You can download a prebuilt docker image by running:
```
docker pull electrikspace/mlir-tutorial:v1
```
Then you can run the docker and work inside with:
```
docker run -it electrikspace/mlir-tutorial:v1
```
If you want edit files locally and build with from the docker, we suggest you to clone the project and use the *in-docker* script, which basically run a command inside the docker env.
```
git clone https://github.com/mlir-school/mlir-list.git
chmod 777 mlir-list
cd mlir-list
./in-docker ./build.sh
```

### Option 2: With prebuilt packages

If you want to work locally, a prebuilt llvm-project with MLIR is available as a Python package.

First, you need to install some dependancies and utils. The following commands have been tested on *Ubuntu24.10*:
```
sudo apt install python3 python3-pip python3-venv git clang lld
```
*Note: lld allows you to reduce the link time of mlir binaries over ld*

Create a Python virtual env (recommended):
```
python3 -m venv venv
source venv/bin/activate
```
Install some Python dependancies:
```
pip install lit pybind11 cmake ninja nanobind
```
Then install the prebuilt llvm-project with:
```
pip install --index-url https://gitlab.inria.fr/api/v4/groups/corse/-/packages/pypi/simple mlir-dev
```
Finally clone the session's project:
```
git clone https://github.com/mlir-school/mlir-list.git && cd mlir-list
```

### Test your installation

To test your installation, you can run the build script in the root directory of *mlir-list*:
```
./build.sh
```
If everything goes well, then your are ready! 
