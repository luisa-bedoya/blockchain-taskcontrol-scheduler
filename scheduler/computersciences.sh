#!/bin/bash


#Computer Sciences Org 

export CHANNEL_NAME=scheduler
export CHAINCODE_NAME=taskcontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/university.com/orderers/orderer.university.com/msp/tlscacerts/tlsca.university.com-cert.pem
export MACHINE=computersciences
export LIST=$4
export STATUS=$5

peer chaincode invoke -o orderer.university.com:7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME -c "{\"Args\":[\"Set\",\"${LIST}\",\"${1}\",\"${2}\",\"${3}\",\"${STATUS}\",\"${MACHINE}\"]}"




