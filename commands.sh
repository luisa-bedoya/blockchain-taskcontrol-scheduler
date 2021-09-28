#!/bin/bash

#generate cryto files
cryptogen generate --config=./crypto-config.yaml
configtxgen -profile OrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile OrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID scheduler

#anchopeer for each org
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ComputerSciencesOrgMSPanchors.tx -channelID scheduler -asOrg ComputerSciencesOrgMSP
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ExactSciencesOrgMSPanchors.tx -channelID scheduler -asOrg ExactSciencesOrgMSP
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/EngineeringOrgMSPanchors.tx -channelID scheduler -asOrg EngineeringOrgMSP
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ResearchOrgMSPanchors.tx -channelID scheduler -asOrg ResearchOrgMSP
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/ChemicalOrgMSPanchors.tx -channelID scheduler -asOrg ChemicalOrgMSP
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/StatisticsOrgMSPanchors.tx -channelID scheduler -asOrg StatisticsOrgMSP

#create infrastucture
export VERBOSE=false
export FABRIC_CFG_PATH=$PWD
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

#Run inside cli

export CHANNEL_NAME=scheduler

#create channel
peer channel create -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem

#join to channel for each org
peer channel join -b scheduler.block
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/users/Admin@exactsciencesorg.university.com/msp CORE_PEER_ADDRESS=peer0.exactsciencesorg.university.com:7051 CORE_PEER_LOCALMSPID="ExactSciencesOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/peers/peer0.exactsciencesorg.university.com/tls/ca.crt peer channel join -b scheduler.block
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/users/Admin@engineeringorg.university.com/msp CORE_PEER_ADDRESS=peer0.engineeringorg.university.com:7051 CORE_PEER_LOCALMSPID="EngineeringOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/peers/peer0.engineeringorg.university.com/tls/ca.crt peer channel join -b scheduler.block
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/users/Admin@researchorg.university.com/msp CORE_PEER_ADDRESS=peer0.researchorg.university.com:7051 CORE_PEER_LOCALMSPID="ResearchOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/peers/peer0.researchorg.university.com/tls/ca.crt peer channel join -b scheduler.block
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/users/Admin@chemicalorg.university.com/msp CORE_PEER_ADDRESS=peer0.chemicalorg.university.com:7051 CORE_PEER_LOCALMSPID="ChemicalOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/peers/peer0.chemicalorg.university.com/tls/ca.crt peer channel join -b scheduler.block
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/users/Admin@statisticsorg.university.com/msp CORE_PEER_ADDRESS=peer0.statisticsorg.university.com:7051 CORE_PEER_LOCALMSPID="StatisticsOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/peers/peer0.statisticsorg.university.com/tls/ca.crt peer channel join -b scheduler.block

#update anchor peers for each org
peer channel update -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/ComputerSciencesOrgMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/users/Admin@exactsciencesorg.university.com/msp CORE_PEER_ADDRESS=peer0.exactsciencesorg.university.com:7051 CORE_PEER_LOCALMSPID="ExactSciencesOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/peers/peer0.exactsciencesorg.university.com/tls/ca.crt peer channel update -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/ExactSciencesOrgMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/users/Admin@engineeringorg.university.com/msp CORE_PEER_ADDRESS=peer0.engineeringorg.university.com:7051 CORE_PEER_LOCALMSPID="EngineeringOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/peers/peer0.engineeringorg.university.com/tls/ca.crt peer channel update -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/EngineeringOrgMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/users/Admin@chemicalorg.university.com/msp CORE_PEER_ADDRESS=peer0.chemicalorg.university.com:7051 CORE_PEER_LOCALMSPID="ChemicalOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/peers/peer0.chemicalorg.university.com/tls/ca.crt peer channel update -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/ChemicalOrgMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/users/Admin@statisticsorg.university.com/msp CORE_PEER_ADDRESS=peer0.statisticsorg.university.com:7051 CORE_PEER_LOCALMSPID="StatisticsOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/peers/peer0.statisticsorg.university.com/tls/ca.crt peer channel update -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/StatisticsOrgMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/users/Admin@researchorg.university.com/msp CORE_PEER_ADDRESS=peer0.researchorg.university.com:7051 CORE_PEER_LOCALMSPID="ResearchOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/peers/peer0.researchorg.university.com/tls/ca.crt peer channel update -o orderer.university.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/ResearchOrgMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem

export CHANNEL_NAME=scheduler
export CHAINCODE_NAME=taskscontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem

#create package chaincode
peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION}

#install package chaincode on computer sciences
peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
#the operation returns a chaincode code package identifier: taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf
#install package chaincode on exactsciences
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/users/Admin@exactsciencesorg.university.com/msp CORE_PEER_ADDRESS=peer0.exactsciencesorg.university.com:7051 CORE_PEER_LOCALMSPID="ExactSciencesOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/peers/peer0.exactsciencesorg.university.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
#install package chaincode on engineering
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/users/Admin@engineeringorg.university.com/msp CORE_PEER_ADDRESS=peer0.engineeringorg.university.com:7051 CORE_PEER_LOCALMSPID="EngineeringOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/peers/peer0.engineeringorg.university.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
#install package chaincode on research
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/users/Admin@researchorg.university.com/msp CORE_PEER_ADDRESS=peer0.researchorg.university.com:7051 CORE_PEER_LOCALMSPID="ResearchOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/peers/peer0.researchorg.university.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
#install package chaincode on chemical
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/users/Admin@chemicalorg.university.com/msp CORE_PEER_ADDRESS=peer0.chemicalorg.university.com:7051 CORE_PEER_LOCALMSPID="ChemicalOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/peers/peer0.chemicalorg.university.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz
#install package chaincode on statistics
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/users/Admin@statisticsorg.university.com/msp CORE_PEER_ADDRESS=peer0.statisticsorg.university.com:7051 CORE_PEER_LOCALMSPID="StatisticsOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/peers/peer0.statisticsorg.university.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

#endorsement policy for lifecycle chaincode
peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --package-id taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf

#commit the chaincode for computer sciences
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --output json
#it returns a json like
# {
#	"approvals": {
#		"ChemicalOrgMSP": false,
#		"ComputerSciencesOrgMSP": true,
#		"EngineeringOrgMSP": false,
#		"ExactSciencesOrgMSP": false,
#		"ResearchOrgMSP": false,
#		"StatisticsOrgMSP": false
#	 }
# }

#let exactsciences approve the chaincode package
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/users/Admin@exactsciencesorg.university.com/msp CORE_PEER_ADDRESS=peer0.exactsciencesorg.university.com:7051 CORE_PEER_LOCALMSPID="ExactSciencesOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/peers/peer0.exactsciencesorg.university.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --package-id taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf
#it returns the confirmation of the transation like:
#	2021-08-15 02:18:31.038 UTC [chaincodeCmd] ClientWait -> INFO 114 txid [3188fc551401eb13b91440d7cd09c46bb36e0c71af52f498dd9787071bc81462] committed with status (VALID) at peer0.exactsciencesorg.university.com:7051

#let engineering approve the chaincode package
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/users/Admin@engineeringorg.university.com/msp CORE_PEER_ADDRESS=peer0.engineeringorg.university.com:7051 CORE_PEER_LOCALMSPID="EngineeringOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/peers/peer0.engineeringorg.university.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --package-id taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf
#let statistics approve the chaincode package
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/users/Admin@statisticsorg.university.com/msp CORE_PEER_ADDRESS=peer0.statisticsorg.university.com:7051 CORE_PEER_LOCALMSPID="StatisticsOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/peers/peer0.statisticsorg.university.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --package-id taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf
#let chemical approve the chaincode package
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/users/Admin@chemicalorg.university.com/msp CORE_PEER_ADDRESS=peer0.chemicalorg.university.com:7051 CORE_PEER_LOCALMSPID="ChemicalOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/peers/peer0.chemicalorg.university.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --package-id taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf
#let research approve the chaincode package
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/users/Admin@researchorg.university.com/msp CORE_PEER_ADDRESS=peer0.researchorg.university.com:7051 CORE_PEER_LOCALMSPID="ResearchOrgMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/peers/peer0.researchorg.university.com/tls/ca.crt peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')" --package-id taskcontrol_1:a6d8b7e24a813166598d248cb6d4af65d9f3b8fcf2e5c6d1451ffac38e99eebf

#commit chaincode. Note that we need to specify peerAddresses of all the orgs (and their CA as TLS is enabled).
peer lifecycle chaincode commit -o orderer.university.com:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.computersciencesorg.university.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/computersciencesorg.university.com/peers/peer0.computersciencesorg.university.com/tls/ca.crt --peerAddresses peer0.exactsciencesorg.university.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/exactsciencesorg.university.com/peers/peer0.exactsciencesorg.university.com/tls/ca.crt --peerAddresses peer0.engineeringorg.university.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/engineeringorg.university.com/peers/peer0.engineeringorg.university.com/tls/ca.crt --peerAddresses peer0.statisticsorg.university.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/peers/peer0.statisticsorg.university.com/tls/ca.crt --peerAddresses peer0.researchorg.university.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researchorg.university.com/peers/peer0.researchorg.university.com/tls/ca.crt --peerAddresses peer0.chemicalorg.university.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/chemicalorg.university.com/peers/peer0.chemicalorg.university.com/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('ComputerSciencesOrgMSP.peer','ExactSciencesOrgMSP.peer','EngineeringOrgMSP.peer','StatisticsOrgMSP.peer', 'ChemicalOrgMSP.peer', 'ResearchOrgMSP.peer')"
#it returns the confirmation of the transactions like:
#	2021-08-15 04:16:06.173 UTC [chaincodeCmd] ClientWait -> INFO 0d6 txid [d11a5a2c9138577072f07f00c9a38888c31a7340a273b740920877b1eb0d5097] committed with status (VALID) at peer0.computersciencesorg.university.com:7051
#	2021-08-15 04:16:06.176 UTC [chaincodeCmd] ClientWait -> INFO 0d7 txid [d11a5a2c9138577072f07f00c9a38888c31a7340a273b740920877b1eb0d5097] committed with status (VALID) at peer0.researchorg.university.com:7051
#	2021-08-15 04:16:06.199 UTC [chaincodeCmd] ClientWait -> INFO 0d8 txid [d11a5a2c9138577072f07f00c9a38888c31a7340a273b740920877b1eb0d5097] committed with status (VALID) at peer0.engineeringorg.university.com:7051
#	2021-08-15 04:16:06.255 UTC [chaincodeCmd] ClientWait -> INFO 0d9 txid [d11a5a2c9138577072f07f00c9a38888c31a7340a273b740920877b1eb0d5097] committed with status (VALID) at peer0.exactsciencesorg.university.com:7051
#	2021-08-15 04:16:06.264 UTC [chaincodeCmd] ClientWait -> INFO 0da txid [d11a5a2c9138577072f07f00c9a38888c31a7340a273b740920877b1eb0d5097] committed with status (VALID) at peer0.chemicalorg.university.com:7051
#	2021-08-15 04:16:06.299 UTC [chaincodeCmd] ClientWait -> INFO 0db txid [d11a5a2c9138577072f07f00c9a38888c31a7340a273b740920877b1eb0d5097] committed with status (VALID) at peer0.statisticsorg.university.com:7051

peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --output json
#it returns all the data related with the commit done 
# {
#	"sequence": 1,
#	"version": "1",
#	"endorsement_plugin": "escc",
#	"validation_plugin": "vscc",
#	"validation_parameter": "CrQBEhwSGggBEgIIABICCAESAggCEgIIAxICCAQSAggFGhwSGgoWQ29tcHV0ZXJTY2llbmNlc09yZ01TUBADGhkSFwoTRXhhY3RTY2llbmNlc09yZ01TUBADGhcSFQoRRW5naW5lZXJpbmdPcmdNU1AQAxoWEhQKEFN0YXRpc3RpY3NPcmdNU1AQAxoUEhIKDkNoZW1pY2FsT3JnTVNQEAMaFBISCg5SZXNlYXJjaE9yZ01TUBAD",
#	"collections": {},
#	"approvals": {
#		"ChemicalOrgMSP": true,
#		"ComputerSciencesOrgMSP": true,
#		"EngineeringOrgMSP": true,
#		"ExactSciencesOrgMSP": true,
#		"ResearchOrgMSP": true,
#		"StatisticsOrgMSP": true
#	}
# }
#chaincode is committed and useable in the fabric network

#Chaincode usage
#INIT LEDGER
#peer chaincode invoke -o orderer.univalle.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["InitLedger"]}'
#
#you should do a invocation of the functions defined on the chaincode by 'peer chaincode invoke'
#'{"Args":["NameOfFunction","ParameterFunction1","..","ParameterFunctionN"}'
#for example to do a invocation of function Set
peer chaincode invoke -o orderer.university.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Set","ToDo","luisa","tarea-machine-learning","no description","Running","exact-sciences-machine"]}'
#for example to do a invocation of function Query
peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Query","ToDo","user","name-user"]}'



