#!/bin/sh
set -e

gum confirm '
Are you ready to start?
Feel free to say "No" and inspect the script if you prefer setting up resources manually.
' || exit 0

###########
# Destroy #
###########

git pull

rm apps/*.yaml

git add .

git commit -m "Destroy"

git push

COUNTER=$(kubectl get managed --no-headers | grep -v database | wc -l)

while [ $COUNTER -ne 0 ]; do
    sleep 10
    echo "Waiting for $COUNTER resources to be deleted"
    COUNTER=$(kubectl get managed --no-headers | grep -v database | wc -l)
done