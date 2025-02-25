#! /bin/sh

curl \
  --verbose \
  --location \
  --output ./gma.zip \
  --cookie "tx_cslightpowershop_eula=1" \
  "$(cat "`dirname $0`/download.url")"
