FROM ubuntu:16.04
LABEL maintainer="Michael Lynch <michael@mtlynch.io>"

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential

ADD . /crfpp
WORKDIR /crfpp

RUN ./configure && \
    make && \
    make install && \
    ldconfig

# Clean up.
RUN rm -rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc && \
    rm -Rf /usr/share/man && \
    apt-get autoremove -y && \
    apt-get clean
