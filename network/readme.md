# Setting up the network
1. Start by setting up `crypto-config.yaml`
2. Then, `configtx.yaml`

## Generating crypto material
Execute  `cryptogen  generate --config=./crypto-config.yaml` in the root folder i.e. network directory

## Create genesis block and configuration transactions
Go and run setup.sh

## Configure docker compose

## Start the containers
docker-compose -f docker-compose.yml up -d ca.coffeechain.com orderer.coffeechain.com peer0.cooperative.coffeechain.com  peer1.cooperative.coffeechain.com peer0.transport.coffeechain.com peer1.transport.coffeechain.com peer0.insurance.coffeechain.com peer1.insurance.coffeechain.com
peer0.miller.coffeechain.com peer1.miller.coffeechain.com couchdb








