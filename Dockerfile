# Use a base image with CUDA support
# FROM nvidia/cuda:12.3.1-base-ubuntu20.04
FROM ubuntu:20.04

WORKDIR /firefly

# Install necessary packages
RUN apt-get update && \
    apt-get remove --purge --auto-remove cmake && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils \
    build-essential \
    make \
    clang \
    llvm \
    tar \
    wget \
    curl \
    g++ \
    gcc \
    clang \
    clang-tools \
    libfindbin-libs-perl \
    apt-utils \
    build-essential \
    libssl-dev \
    git && \
    rm -rf /var/lib/apt/lists/*

# Installing Cmake
RUN version=3.28 && \
    build=1 && \
    mkdir temp && cd temp && \
    wget https://cmake.org/files/v3.28/cmake-3.28.1.tar.gz && \
    cd /firefly/temp && tar -xzvf cmake-3.28.1.tar.gz && cd /firefly/temp/cmake-3.28.1/ && ./bootstrap && make -j$(nproc) && make install

# Installing cuda
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda-repo-ubuntu2004-12-3-local_12.3.2-545.23.08-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2004-12-3-local_12.3.2-545.23.08-1_amd64.deb && \
    mv /var/cuda-repo-ubuntu2004-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get install -y cuda-toolkit-12-3 && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for CUDA
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

ENTRYPOINT [ "tail", "-f", "/dev/null"]
