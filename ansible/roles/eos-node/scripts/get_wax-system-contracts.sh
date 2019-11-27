#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
WAX_SYSTEM_CONTRACTS_VERSION=$1
DOWNLOAD_DIR=$SCRIPT_DIR/tmp
RESULT_DIR=$SCRIPT_DIR/../files/contracts

if [ -z $WAX_SYSTEM_CONTRACTS_VERSION ]; then
    echo "Syntax: $0 <WAX System Contracts Version>"
    exit 1
fi

# Prepare & download
mkdir -p $DOWNLOAD_DIR
rm -rf $DOWNLOAD_DIR/wax-system-contracts

pushd $DOWNLOAD_DIR
git clone -b $WAX_SYSTEM_CONTRACTS_VERSION https://github.com/worldwide-asset-exchange/wax-system-contracts.git

# Build and test contracts
cd wax-system-contracts
make dev-docker-all

if [ ! $? = 0 ]; then
    echo "WAX System Contracts building/testing has failed. Code = $?"
    exit 2
fi

# Ready for deployment
mkdir -p $RESULT_DIR
rm -rf $RESULT_DIR/.*
cp -r build/contracts/eosio.* $RESULT_DIR

popd

