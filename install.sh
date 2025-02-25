#! /bin/sh
set -e

VERSION=2.2.1
FULLVERSION=2.2.1.1

apt update -y
apt install -y \
  unzip libxml2-utils curl

curl \
  --verbose \
  --location \
  --output ./gma.zip \
  --cookie "tx_cslightpowershop_eula=1" \
  "$(cat "`dirname $0`/download.url")"

unzip -o gma.zip -d /tmp/grandMA3_stick_v${FULLVERSION}
cd /tmp/grandMA3_stick_v${FULLVERSION}/ma/
xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@Destination' release_stick_v${FULLVERSION}.xml | sed "s/ Destination=/mkdir -p /" | sed "s/home\/ma/root/" | sh
xmllint -xpath '//GMA3/ReleaseFile/MAPacket[not(contains(@Type, "sys")) and not(contains(@Type, "arm")) and not(contains(@Type, "gma2"))]/@*[name()="Name" or name()="Destination"]' release_stick_v${FULLVERSION}.xml | sed "s/ Destination=/ -d /" | tr -d "\n" | sed "s/ Name=/\nunzip -o /g" | sed "s/home\/ma/root/" | sh

echo "#!/bin/sh
sudo LD_LIBRARY_PATH=/root/MALightingTechnology/gma3_$VERSION/shared/third_party /root/MALightingTechnology/gma3_$VERSION/console/bin/app_gma3 HOSTTYPE=onPC" > /usr/bin/gma3_${VERSION}
chmod +x /usr/bin/gma3_${VERSION} 
