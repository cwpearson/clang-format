# Stage 1: Build environment
FROM docker.io/redhat/ubi8 AS builder

LABEL org.opencontainers.image.source https://github.com/cwpearson/clang-format

RUN dnf install -y \
    cmake \
    gcc \
    gcc-c++ \
    python3 \
    wget \
    xz \
    && dnf clean all

RUN wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/llvm-project-16.0.6.src.tar.xz \
    && tar -xf llvm-project-16.0.6.src.tar.xz
RUN cmake -S llvm-project-16.0.6.src/llvm -B build \
  -DLLVM_ENABLE_PROJECTS='clang' \
  -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DLLVM_TARGETS_TO_BUILD=""
RUN make -C build -j$(nproc) install

# base final image off ubi8-micro
FROM docker.io/redhat/ubi8-micro

# clang-format-16 links this
COPY --from=builder /lib64/libstdc++.so.6 /lib64/libstdc++.so.6
# keep clang-format binary only
COPY --from=builder /usr/local/bin/clang-format /usr/local/bin/clang-format
# also provide clang-format-16
RUN ln -s /usr/local/bin/clang-format /usr/local/bin/clang-format-16

# expect caller to map $PWD into /src with -v flag
WORKDIR /src
