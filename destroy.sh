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

rm -rf apps/*.yaml

git add .

git commit -m "Destroy"

git push

COUNTER=$(kubectl --namespace a-team get managed --no-headers | wc -l)

while [ $COUNTER -ne 0 ]; do
    sleep 10
    echo "Waiting for $COUNTER resources to be deleted"
    COUNTER=$(kubectl get managed --no-headers | wc -l)
done

if [[ "$HYPERSCALER" == "google" ]]; then

    gcloud projects delete $PROJECT_ID --quiet

fi

kind delete cluster
