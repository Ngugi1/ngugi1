# Global variables
CHANNEL_NAME="coffeechainchannel"

# remove crypto-config directory
cd network
rm -rf crypto-config/
# empty channel-artifacts directory
cd network/channel-artifacts rm *
# kill and remove docker containers
docker kill $(docker ps -aq) # return error if no running containers
docker rm $(docker ps -aq) #  return error if no containers
docker ps # see no running containers


# Generate crypto materials
cryptogen  generate --config=./crypto-config.yaml

# Create genesis block for the orderer
configtxgen -profile SampleMultiNodeEtcdRaft -channelID coffeechain-sys-channel  -outputBlock ./channel-artifacts/genesis.block

# Generating channel configuration transaction 'channel.tx'
configtxgen -profile CoffeeChainChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

# # Generate Anchor Peers for all orgs
configtxgen -profile CoffeeChainChannel -outputAnchorPeersUpdate ./channel-artifacts/CooperativeOrgMSPanchors.tx -channelID $CHANNEL_NAME -asOrg CooperativeOrgMSP
configtxgen -profile CoffeeChainChannel -outputAnchorPeersUpdate ./channel-artifacts/TransportOrgMSPanchors.tx -channelID $CHANNEL_NAME -asOrg TransportOrgMSP
configtxgen -profile CoffeeChainChannel -outputAnchorPeersUpdate ./channel-artifacts/MillerOrgMSPanchors.tx -channelID $CHANNEL_NAME -asOrg MillerOrgMSP
configtxgen -profile CoffeeChainChannel -outputAnchorPeersUpdate ./channel-artifacts/InsuranceOrgMSPanchors.tx -channelID $CHANNEL_NAME -asOrg InsuranceOrgMSP

# Start the docker containers
docker-compose -f docker-compose.yml up -d ca.coffeechain.com orderer.coffeechain.com peer0.cooperative.coffeechain.com  peer1.cooperative.coffeechain.com peer0.transport.coffeechain.com peer1.transport.coffeechain.com peer0.insurance.coffeechain.com peer1.insurance.coffeechain.com
peer0.miller.coffeechain.com peer1.miller.coffeechain.com couchdb

# Start the CAs
docker-compose -f docker-compose-ca.yaml up -d

# Bring up orderes and peers
docker-compose -f docker-compose-cli.yaml up -d