#!/bin/bash

set -e

api_key="{{cdn_api_key}}"
api_email="{{cdn_api_email}}"
iojs_id="{{cdn_api_iojs_id}}"
nodejs_id="{{cdn_api_nodejs_id}}"

site=$1

if [ "X$site" == "Xiojs" ]; then
  zone_id="${iojs_id}"
elif [ "X$site" == "Xnodejs" ]; then
  zone_id="${nodejs_id}"
elif [ "X$site" == "X" ]; then
  # no arg? try both then
  "$0" nodejs
  "$0" iojs
  exit 0
else
  echo "Usage: cdn-purge.sh < iojs | nodejs >"
  exit 1
fi

if ! [ -f /tmp/cdnpurge.$site ]; then
  exit 0
fi

rm -f /tmp/cdnpurge.$site

# list zones:
#
#curl -X GET \
#  "https://api.cloudflare.com/client/v4/zones/" \
#  -H "X-Auth-Email: ${api_email}" \
#  -H "X-Auth-Key: ${api_key}"

# purge full cache
curl -X DELETE \
  "https://api.cloudflare.com/client/v4/zones/${zone_id}/purge_cache" \
  -H "X-Auth-Email: ${api_email}" \
  -H "X-Auth-Key: ${api_key}" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
