FROM ubuntu:16.04
LABEL maintainer="Michael Lynch <michael@mtlynch.io>"

RUN apt-get update --yes
RUN apt-get upgrade --yes
RUN apt-get install --yes \
      build-essential \
      git \
      python2.7 \
      python-pip
RUN pip install --upgrade pip

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
