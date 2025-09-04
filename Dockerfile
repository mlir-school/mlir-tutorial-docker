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
  nano \
  clang \
  cmake \
  cmake-curses-gui \
  git \
  lld \
  man-db \
  ninja-build \
  pybind11-dev \
  python3 \
  python3-numpy \
  python3-pybind11 \
  python3-yaml \
  python3-pip \
  unzip \
  wget \
  xz-utils && \
  sudo apt-get clean
RUN pip3 install --no-cache-dir --break-system-packages lit
RUN git clone https://github.com/wjakob/nanobind && \
  cd nanobind && \
  git submodule update --init --recursive && \
  cmake \
    -G Ninja \
    -B build \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_INSTALL_PREFIX=$HOME/usr && \
  cmake --build build --target install && \
  cd
ENV CMAKE_PREFIX_PATH=/home/mlir/usr
RUN wget -nv https://github.com/llvm/llvm-project/archive/4af268c84f530de795f3a221b80d9ca11c06f072.zip -O llvm-source.zip && \
  unzip -q llvm-source.zip && \ 
  mv llvm-project-4af268c84f530de795f3a221b80d9ca11c06f072 llvm-project && \
  rm llvm-source.zip
WORKDIR /home/mlir/llvm-project
RUN mkdir -p install
RUN cmake llvm \
  -G Ninja \
  -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=./install \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_PREFIX_PATH=$HOME/usr \
  -DLLVM_BUILD_EXAMPLES=False \
  -DLLVM_TARGETS_TO_BUILD="Native" \
  -DLLVM_ENABLE_ASSERTIONS=False \
  -DLLVM_ENABLE_LLD=On \
  -DLLVM_ENABLE_PROJECTS="mlir" \
  -DLLVM_USE_SPLIT_DWARF=On \
  -DMLIR_ENABLE_BINDINGS_PYTHON=On \
  -DLLVM_BUILD_LLVM_DYLIB=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  -DMLIR_LINK_MLIR_DYLIB=ON \
  -DMLIR_BUILD_MLIR_C_DYLIB=ON \
  -DLLVM_INSTALL_UTILS=ON \
  -DMLIR_INCLUDE_INTEGRATION_TESTS=False
RUN cmake --build build -t mlir-opt mlir-translate mlir-runner check-mlir install && rm -rf build
ENV LLVM_PREFIX=/home/mlir/llvm-project/install
ENV PATH=/home/mlir/.local/bin:$PATH
ENV PATH=/home/mlir/llvm-project/install/bin:$PATH
RUN git clone https://github.com/ElectrikSpace/mlir-list.git /home/mlir/mlir-list
WORKDIR /home/mlir/mlir-list
