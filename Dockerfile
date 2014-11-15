## Image to build from sources

FROM debian:latest
MAINTAINER XiVO Team "dev@avencall.com"

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Add dependencies
RUN apt-get -qq update
RUN apt-get -qq -y install \
    wget \
    apt-utils \
    git \
    maven \
    openjdk-7-jdk


# XiVO javalib
WORKDIR /usr/src/
RUN git clone https://gitorious.org/xivo/xivo-javactilib.git
WORKDIR /usr/src/xivo-javactilib/
RUN mvn install

# SBT
WORKDIR /usr/src/
ADD https://dl.bintray.com/sbt/debian/sbt-0.13.6.deb /usr/src/
RUN dpkg -i sbt-0.13.6.deb

# akka-quartz
WORKDIR /usr/src/
RUN git clone https://github.com/theatrus/akka-quartz.git
WORKDIR /usr/src/akka-quartz
RUN sbt publish-local

# install play
WORKDIR /usr/src/
ADD http://downloads.typesafe.com/typesafe-activator/1.2.10/typesafe-activator-1.2.10-minimal.zip /usr/src/
RUN unzip typesafe-activator-1.2.10-minimal.zip
RUN mv /usr/src/activator-1.2.10-minimal /usr/src/activator

# xuc server
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xuc/xucserver.git

# xuc mod
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xuc/xucmod.git

# Run xucserver
WORKDIR /usr/src/xucserver
#WORKDIR /usr/src/xucmod
ENTRYPOINT /usr/src/activator/activator make-site
