FROM ubuntu:16.04
LABEL maintainer="Michael Lynch <michael@mtlynch.io>"

RUN apt-get update --yes
RUN apt-get upgrade --yes
RUN apt-get install --yes \
      automake \
      autoconf \
      build-essential \
      git \
      libtool \
      libyaml-dev \
      make \
      python3 \
      python3-dev \
      python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install Cython==0.29.10

RUN mkdir /libyaml
WORKDIR /libyaml
ARG LIBYAML_VERSION="dist-0.2.2"
RUN git clone https://github.com/yaml/libyaml.git . && \
    git checkout "$LIBYAML_VERSION" && \
    autoreconf -f -i && \
    ./configure && \
    make && \
    make install

RUN mkdir /pyyaml
WORKDIR /pyyaml
ARG PYYAML_VERSION="3.13"
RUN git clone https://github.com/yaml/pyyaml.git . && \
    git checkout "$PYYAML_VERSION" && \
    python3 setup.py install

ADD . /crfpp
WORKDIR /crfpp

RUN ./configure && \
    make && \
    make install && \
    ldconfig

# Clean up.
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc && \
    rm -rf /usr/share/man && \
    apt-get autoremove -y && \
    apt-get clean
