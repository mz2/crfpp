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
      python2.7 \
      python-dev \
      python-pip
RUN pip install --upgrade pip
RUN pip install Cython==0.29.10

RUN mkdir /libyaml
WORKDIR /libyaml
RUN git clone https://github.com/yaml/libyaml.git . && \
    git checkout dist-0.2.2 && \
    autoreconf -f -i && \
    ./configure && \
    make && \
    make install

RUN mkdir /pyyaml
WORKDIR /pyyaml
RUN git clone https://github.com/yaml/pyyaml.git . && \
    git checkout 5.1.1 && \
    python setup.py install

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
