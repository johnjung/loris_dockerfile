FROM ubuntu:16.04

# Set up a Loris server with Python 3 in Docker for testing. To automatically
# start the server, uncomment the CMD at the bottom of this file.

MAINTAINER jej@uchicago.edu

ENV HOME /root

RUN apt-get update -y
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa

# Update packages and install tools 
RUN apt-get update -y && apt-get install -y wget git unzip

RUN apt-get install -y python3.7

# Install pip and python libs
RUN apt-get install -y python3-dev python3-setuptools python3-pip

RUN python3.7 -m pip install --upgrade pip

RUN python3.7 -m pip install install Werkzeug

RUN python3.7 -m pip install configobj

# Install kakadu
WORKDIR /usr/local/lib
RUN wget --no-check-certificate https://github.com/loris-imageserver/loris/raw/development/lib/Linux/x86_64/libkdu_v74R.so \
	&& chmod 755 libkdu_v74R.so

WORKDIR /usr/local/bin
RUN wget --no-check-certificate https://github.com/loris-imageserver/loris/raw/development/bin/Linux/x86_64/kdu_expand \
	&& chmod 755 kdu_expand

RUN ln -s /usr/lib/`uname -i`-linux-gnu/libfreetype.so /usr/lib/ \
	&& ln -s /usr/lib/`uname -i`-linux-gnu/libjpeg.so /usr/lib/ \
	&& ln -s /usr/lib/`uname -i`-linux-gnu/libz.so /usr/lib/ \
	&& ln -s /usr/lib/`uname -i`-linux-gnu/liblcms.so /usr/lib/ \
	&& ln -s /usr/lib/`uname -i`-linux-gnu/libtiff.so /usr/lib/ \

RUN echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig

# Install Pillow
RUN apt-get install -y libjpeg8 libjpeg8-dev libfreetype6 libfreetype6-dev zlib1g-dev liblcms2-2 liblcms2-dev liblcms2-utils libtiff5-dev

RUN python3.7 -m pip install Pillow

# Install loris
WORKDIR /opt

# Get loris.
RUN git clone https://github.com/loris-imageserver/loris.git

RUN useradd -d /var/www/loris -s /sbin/false loris

RUN apt-get install -y libffi-dev libssl-dev 

WORKDIR /opt/loris

# Create image directory
RUN mkdir /usr/local/share/images

# Load example images
RUN cp -R tests/img/* /usr/local/share/images/

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ./setup.py install 


WORKDIR /opt/loris/loris

EXPOSE 5004

#CMD ["python", "webapp.py"]
CMD ["tail", "-f", "/dev/null"]
