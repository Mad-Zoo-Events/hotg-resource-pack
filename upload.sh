#!/bin/bash
if [ -z "$1" ]; then
    echo "usage:"
    echo -e "./upload.sh \"your commit message goes here\""
    exit 1
fi

rm out/HOTG.zip

(cd src && zip -9 -r ../out/HOTG.zip .)

CURRENT_VERSION=$(aws s3 ls s3://madzoo.events/packs/ | grep -o "HOTG.*.zip" | sed "s/[^0-9+]//g")

if [ -z "$CURRENT_VERSION" ]; then
    echo "failed to get version number... Aborting"
    exit 1
fi

NEXT_VERSION=$((CURRENT_VERSION + 1))

aws s3 cp "out/HOTG.zip s3://madzoo.events/packs/HOTG${NEXT_VERSION}.zip"
aws s3 rm "s3://madzoo.events/packs/HOTG${CURRENT_VERSION}.zip"

git add src/ out/
git commit -m "$1"
git push
