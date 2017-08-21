FROM centos:7
MAINTAINER Charles Zilm <ch@rleszilm.com>

## Environment Variables
ENV ERLANG_VERSION=20.0
ENV ELIXIR_VERSION=1.5.1
ENV RUST_VERSION=1.19.0

## Install base packages
RUN yum install -y file
RUN yum install -y wget
RUN yum install -y epel-release
RUN yum install -y which

## Install tools
RUN yum install -y git

## Install compilers
RUN yum install -y gcc-c++
RUN curl -sO https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xzf rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz && \
    ./rust-$RUST_VERSION-x86_64-unknown-linux-gnu/install.sh --without=rust-docs && \
    rm -rf \
      rust-$RUST_VERSION-x86_64-unknown-linux-gnu \
      rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz \
      /tmp/* \
      /var/tmp/*

## Install Erlang
RUN wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
RUN rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
RUN rm erlang-solutions-1.0-1.noarch.rpm
RUN yum install -y erlang-$ERLANG_VERSION

## Install Elixer
RUN yum install -y unzip
WORKDIR elixir
RUN wget https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip && \
    unzip Precompiled.zip
RUN pwd
RUN chmod a+x bin/* && \
    cp bin/* /usr/bin/ && \
    cp -r lib/* /usr/lib64/erlang/lib/ 

WORKDIR /
RUN rm -rf elixir

## Install rebar3
RUN wget https://s3.amazonaws.com/rebar3/rebar3
RUN mv rebar3 /usr/bin/rebar3
RUN chmod a+x /usr/bin/rebar3

## Make mount point
WORKDIR /src

ENTRYPOINT "/bin/bash"
CMD [""]

