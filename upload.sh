#!/bin/bash
rm out/HOTG.zip

cd src
zip -9 -r ../out/HOTG.zip .
cd ..

CURRENT_VERSION=$(aws s3 ls s3://madzoo.events/packs/ | grep -o "HOTG.*.zip" | sed "s/[^0-9+]//g")
NEXT_VERSION=$((CURRENT_VERSION + 1))

aws s3 rm s3://madzoo.events/packs/HOTG${CURRENT_VERSION}.zip
aws s3 cp out/HOTG.zip s3://madzoo.events/packs/HOTG${NEXT_VERSION}.zip
