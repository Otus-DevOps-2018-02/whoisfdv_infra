#!/bin/bash

if  [[ $1 == "--list" ]]; then
    app_ip=$(gcloud compute instances list --filter="NAME=reddit-app" | (read; cat;) | awk '{print $5}')
    db_ip=$(gcloud compute instances list --filter="NAME=reddit-db" | (read; cat;) | awk '{print $5}')
    sed "s/app_ip/$app_ip/g;s/db_ip/$db_ip/g" old/inventory.json.vars > old/inventory.json
    cat old/inventory.json
fi
