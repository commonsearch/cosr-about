FROM debian:jessie

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    python \
    python-pip \
    python-dev \
    gcc \
    make

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Base directory
RUN mkdir /cosr