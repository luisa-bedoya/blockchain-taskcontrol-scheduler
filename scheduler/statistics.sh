#!/bin/bash


#Statistics Org 

export CHANNEL_NAME=scheduler
export CHAINCODE_NAME=taskcontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem

export MACHINE=statistics
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/users/Admin@statisticsorg.university.com/msp
export CORE_PEER_ADDRESS=peer0.statisticsorg.university.com:7051 
export CORE_PEER_LOCALMSPID="StatisticsOrgMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/statisticsorg.university.com/peers/peer0.statisticsorg.university.com/tls/ca.crt

export LIST=$4
export STATUS=$5

CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE peer chaincode invoke -o orderer.university.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c "{\"Args\":[\"Set\",\"${LIST}\",\"${1}\",\"${2}\",\"${3}\",\"${STATUS}\",\"${MACHINE}\"]}"




