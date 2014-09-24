FROM debian:jessie
MAINTAINER Samuli Elomaa "samuli.elomaa@gmail.com"


RUN apt-get update && apt-get clean
RUN apt-get install -q -y openjdk-7-jre-headless openjdk-7-jdk rubygems wget && apt-get clean
RUN mkdir /zap 
RUN gem install zapr
RUN cd /zap && wget http://downloads.sourceforge.net/project/zaproxy/2.3.1/ZAP_2.3.1_Linux.tar.gz
RUN cd /zap && tar -zxvf ZAP_2.3.1_Linux.tar.gz 

RUN useradd -d /home/zap -m -s /bin/bash zap 
RUN echo zap:zap | chpasswd

RUN apt-get install -y git x11vnc xvfb openbox xterm net-tools python-numpy
RUN mkdir /home/zap/.vnc
# use this to create static pass for x11vnc
#RUN x11vnc -storepasswd zap /home/zap/.vnc/passwd
RUN echo "openbox &" > /home/zap/.xinitrc
RUN echo "xsetroot -solid black" >> /home/zap/.xinitrc
run echo "zap.sh" >> /home/zap/.xinitrc
RUN chmod a+x /home/zap/.xinitrc
RUN chown -R zap /home/zap/
RUN chmod -R u+rw /home/zap/
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV PATH $JAVA_HOME/bin:/zap/ZAP_2.3.1/:$PATH
ENV ZAP_PATH /zap/ZAP_2.3.1/zap.sh
ENV HOME /home/zap/

# For noVNC support. Currently broken. Please fix.
#RUN git clone http://github.com/kanaka/noVNC
#RUN chown -R zap /noVNC/
#RUN chmod -R u+xrw /noVNC/
#RUN echo '#!/bin/sh' > /bin/startzap.sh
#RUN echo 'x11vnc --usepw -passwdfile /home/zap/.vnc/passwd --forever -q -bg --create &' >> /bin/startzap.sh
#RUN echo 'cd /noVNC/utils ' >> /bin/startzap.sh
#RUN echo 'sh launch.sh --vnc localhost:5900' >> /bin/startzap.sh
#RUN chmod a+x /bin/startzap.sh 
