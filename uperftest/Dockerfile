FROM ubuntu:22.04 as build

RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y git gcc make libsctp-dev
RUN git clone https://github.com/uperf/uperf.git
WORKDIR /uperf
RUN apt-get install -y autoconf
RUN git checkout 1.0.7
RUN autoreconf -f -i && ./configure;make
RUN make install

FROM ubuntu:20.04
LABEL author="shw8927"
COPY --from=build /usr/local/bin/uperf /usr/local/bin/uperf

RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt update
RUN apt install -y sysstat libsctp1
RUN sed -i "s/false/true/g" /etc/default/sysstat
RUN service sysstat restart
CMD ["/bin/bash","-c","sleep 36000"]
