FROM ubuntu:24.10
ENV TZ=Europe/Paris DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y sudo
RUN useradd -ms /bin/bash mlir
RUN usermod -aG sudo mlir
RUN echo "mlir:mlir" | chpasswd
RUN echo "mlir ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/mlir
RUN chmod 044 /etc/sudoers.d/mlir
USER mlir
WORKDIR /home/mlir
CMD ["/bin/bash"]
RUN sudo apt-get install -y \
  bash-completion \
  ca-certificates \
  ccache \
  clang \
  cmake \
  cmake-curses-gui \
  lld \
  man-db \
  nanobind-dev \
  ninja-build \
  pybind11-dev \
  python3 \
  python3-nanobind \
  python3-numpy \
  python3-pybind11 \
  python3-yaml \
  wget \
  xz-utils
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/llvm-project-19.1.6.src.tar.xz
RUN tar xf llvm-project-19.1.6.src.tar.xz
RUN mv llvm-project-19.1.6.src llvm-project 
WORKDIR /home/mlir/llvm-project
RUN cmake llvm \
  -G Ninja \
  -B build \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang \
  -DLLVM_BUILD_EXAMPLES=On \
  -DLLVM_BUILD_TARGETS="Native;NVPTX;AMDGPU" \
  -DLLVM_CCACHE_BUILD=On \
  -DLLVM_ENABLE_ASSERTIONS=On \
  -DLLVM_ENABLE_LLD=On \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_USE_SPLIT_DWARF=On \
  -DMLIR_ENABLE_BINDINGS_PYTHON=On \
  -DMLIR_INCLUDE_INTEGRATION_TESTS=On
RUN cmake --build build -t check-mlir
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
