#!/bin/bash
echo ---- Start time $(date)
echo -- set project
gcloud config set project $(gcloud projects list --format='value(name)' --limit=1)

echo Project set to : $(gcloud config list --format 'value(core.project)')


echo -- Build common service first. {time: $(date)}
cd common/build

echo -- Enable the APIs {time: $(date)}
bash enableapis.sh

echo -- Create the network used for Kubernetes and Compute Engine. {time: $(date)}
bash network.sh

echo -- Create the public and private buckets {time: $(date)}
bash privatebucket.sh
bash publicbucket.sh

echo -- Create the pubsub topic  {time: $(date)}
bash pubsub.sh

echo -- Create the bigtable instance {time: $(date)}
bash bigtable.sh

echo -- Create the bigquery table based on the Bigtable schema. {time: $(date)}
bash bigquery.sh


echo -- Setup and deploy the product service. {time: $(date)}
cd ../../products/cloud
bash setup.sh
cd ../deploy
bash deploy.sh


echo -- Setup the ads {time: $(date)}
cd ../../ads/cloud
bash setup.sh
bash deploy.sh

echo ---- Stop time $(date)
