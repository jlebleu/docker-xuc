## Image to build from sources

FROM debian:latest
MAINTAINER XiVO Team "dev@avencall.com"

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

VOLUME /ivy

# Add dependencies
RUN apt-get update
RUN apt-get -y install \
    wget \
    apt-utils \
    devscripts \
    git \
    maven \
    openjdk-7-jdk

#default to java 7
RUN update-java-alternatives -s java-1.7.0-openjdk-amd64

# XiVO javalib
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xivo-utils/xivo-javactilib.git
WORKDIR /usr/src/xivo-javactilib/
RUN mvn install


# install play
WORKDIR /usr/src/
ADD http://downloads.typesafe.com/typesafe-activator/1.2.10/typesafe-activator-1.2.10-minimal.zip /usr/src/
RUN unzip typesafe-activator-1.2.10-minimal.zip
RUN mv /usr/src/activator-1.2.10-minimal /usr/src/activator


#metrics specific 
WORKDIR /usr/src/
RUN git clone https://github.com/jirkah/metrics-play
WORKDIR /usr/src/metrics-play
RUN /usr/src/activator/activator -Dsbt.ivy.home=/ivy publish-local

# xuc stats
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xuc/xucstats.git
WORKDIR /usr/src/xucstats
RUN /usr/src/activator/activator -Dsbt.ivy.home=/ivy publish-local 

# play-authentication
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xivo-recording/play-authentication.git
WORKDIR /usr/src/play-authentication
RUN /usr/src/activator/activator -Dsbt.ivy.home=/ivy publish-local

# xuc mod
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xuc/xucmod.git
WORKDIR /usr/src/xucmod
RUN /usr/src/activator/activator -Dsbt.ivy.home=/ivy publish-local

# xuc server
WORKDIR /usr/src/
RUN git clone https://gitlab.com/xuc/xucserver.git
WORKDIR /usr/src/xucserver
RUN /usr/src/activator/activator -Dsbt.ivy.home=/ivy debian:genChanges

WORKDIR /usr/src/xucserver/target
RUN dpkg -i xuc_2.3.8_all.deb

#build configuration
#edit /usr/share/xuc/conf/xuc.conf
#edit /usr/share/xuc/conf/xuc_logger.xml

# Run xucserver
#WORKDIR /usr/src/xucserver
#WORKDIR /usr/src/xucmod
#ENTRYPOINT /usr/src/activator/activator make-site
