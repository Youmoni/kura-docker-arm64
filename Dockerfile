# FROM resin/rpi-raspbian:stretch
# FROM arm64v8/openjdk:latest
# FROM openjdk:8-jre-stretch
FROM arm64v8/ubuntu:20.04

ARG KURA_VERSION=5.2.1

RUN apt-get update && \
	apt-get --yes install	apt-utils && \
	echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
	apt-get --yes install	bluetooth \
				gdebi-core \
				openjdk-8-jre-headless \
				procps \
				wget \
				i2c-tools \
				usbutils && \
	wget -q http://download.eclipse.org/kura/releases/${KURA_VERSION}/kura_${KURA_VERSION}_raspberry-pi-ubuntu-20_installer-nn.deb && \
	yes | gdebi kura_${KURA_VERSION}_raspberry-pi-ubuntu-20_installer-nn.deb && \
	rm kura_${KURA_VERSION}_raspberry-pi-ubuntu-20_installer-nn.deb && \
	apt-get --yes remove	gdebi-core && \
	apt-get --yes autoremove && \
	apt-get --yes clean

EXPOSE 443

COPY start.sh /

CMD ["/start.sh"]
