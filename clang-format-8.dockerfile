# Stage 1: Build environment
FROM docker.io/redhat/ubi8 AS builder

LABEL maintainer="Carl Pearson <me@carlpearson.net>"
LABEL org.opencontainers.image.title="clang-format 8"
LABEL description="A container with clang-format 8"
LABEL org.opencontainers.image.description="A container with clang-format 8"
LABEL org.opencontainers.image.source https://github.com/cwpearson/clang-format
LABEL org.opencontainers.image.licenses="MIT"
# LABEL version="1.0"
# LABEL org.opencontainers.image.version="1.0"
# LABEL org.opencontainers.image.url="https://example.com"
# LABEL org.opencontainers.image.documentation="https://example.com/docs"
# LABEL org.opencontainers.image.vendor="Example Corp"

RUN dnf install -y \
    cmake \
    gcc \
    gcc-c++ \
    python3 \
    wget \
    xz \
    && dnf clean all

RUN wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/llvm-8.0.1.src.tar.xz \
    && tar -xf llvm-8.0.1.src.tar.xz --no-same-owner
RUN wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/cfe-8.0.1.src.tar.xz \
    && tar -xf cfe-8.0.1.src.tar.xz --no-same-owner
RUN mv cfe-8.0.1.src clang
RUN cmake -S llvm-8.0.1.src -B build \
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
# also provide clang-format-8
RUN ln -s /usr/local/bin/clang-format /usr/local/bin/clang-format-8

# expect caller to map $PWD into /src with -v flag
WORKDIR /src
