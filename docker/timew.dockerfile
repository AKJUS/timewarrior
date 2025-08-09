FROM ubuntu:24.04 AS base

FROM base AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
            asciidoctor \
            cmake \
            g++ \
            git

# Setup language environment
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Add source directory
ADD .. /root/code/
WORKDIR /root/code/

# Build Timewarrior
RUN git clean -dfx && \
    git submodule init && \
    git submodule update && \
    cmake -DCMAKE_BUILD_TYPE=release . && \
    make -j8

FROM base AS runner

# Install Timewarrior
COPY --from=builder --chown=0:0 /root/code/src/timew /usr/local/bin
COPY --from=builder --chown=0:0 /root/code/src/timew/doc/ /usr/local/share/doc/timew/
COPY --from=builder --chown=0:0 /root/code/src/timew/man/ /usr/local/share/man/

# Initialize Timewarrior
RUN timew :yes
