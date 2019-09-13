#!/bin/bash
echo -- set project
gcloud config set project $(gcloud projects list --format='value(name)' --limit=1)

echo Project set to : $(gcloud config list --format 'value(core.project)')


echo -- Build common service first. --
cd common/build

echo -- Enable the APIs
bash enableapis.sh

echo -- Create the network used for Kubernetes and Compute Engine.
bash network.sh

echo -- Create the public and private buckets
bash privatebucket.sh
bash publicbucket.sh

echo -- Create the pubsub topic 
bash pubsub.sh

echo -- Create the bigtable instance
bash bigtable.sh

echo -- Create the bigquery table based on the Bigtable schema.
bash bigquery.sh


echo -- Setup and deploy the product service.
cd ../../products/cloud
bash setup.sh
cd ../deploy
bash deploy.sh


echo -- Setup the ads
cd ../../ads/cloud
bash setup.sh
bash deploy.sh
