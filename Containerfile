FROM docker.io/library/debian:12

ARG VERSION=2.2.1
ARG FULLVERSION=2.2.1.1

COPY ./files/download.sh /
COPY ./files/download.url /
COPY ./files/gma3_${VERSION} /usr/bin/

RUN apt update -y && apt install -y unzip libxml2-utils sudo curl

WORKDIR /

RUN ./download.sh
RUN unzip -o gma.zip -d /grandMA3_stick_v${FULLVERSION}
RUN rm gma.zip
WORKDIR /grandMA3_stick_v${FULLVERSION}/ma/
RUN xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@Destination' release_stick_v${FULLVERSION}.xml | sed "s/ Destination=/mkdir -p /" | sed "s/home\/ma/root/" | sh
RUN xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@*[name()="Name" or name()="Destination"]' release_stick_v${FULLVERSION}.xml | sed "s/ Destination=/ -d /" | tr -d "\n" | sed "s/ Name=/\nunzip -o /g" | sed "s/home\/ma/root/" | sh
